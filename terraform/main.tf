terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "eu-north-1"
}

resource "aws_ecr_repository" "user" {
  name = "user-service"
}

resource "aws_ecr_repository" "product" {
  name = "product-service"
}

resource "aws_ecr_repository" "order" {
  name = "order-service"
}

output "ecr_urls" {
  value = [
    aws_ecr_repository.user.repository_url,
    aws_ecr_repository.product.repository_url,
    aws_ecr_repository.order.repository_url
  ]
}
data "aws_vpc" "existing" {
  id = "vpc-0345fd31f13a5a09b"
}

data "aws_subnet" "existing" {
  id = "subnet-089448b5dfe068d18"
}

data "aws_security_group" "webdemo" {
  id = "sg-021109cd675a1138e"
}

data "aws_security_group" "web" {
  id = "sg-0b65d8b8b6eeb89ad"
}

data "aws_security_group" "launch_wizard" {
  id = "sg-053f903a8d5c56243"
}

resource "aws_instance" "microservices" {
  ami           = "ami-021aaf3749be66813"
  instance_type = "t3.micro"

  subnet_id = data.aws_subnet.existing.id

  vpc_security_group_ids = [
    data.aws_security_group.webdemo.id,
    data.aws_security_group.web.id,
    data.aws_security_group.launch_wizard.id
  ]

  key_name = "psa"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
