
pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-north-1'
        AWS_ACCOUNT_ID = '451971655895'
        ECR_REGISTRY = '451971655895.dkr.ecr.eu-north-1.amazonaws.com'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/dhruva80/aws-microservices-devops.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                    docker build -t user-service ./user-service
                    docker build -t product-service ./product-service
                    docker build -t order-service ./order-service
                '''
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh '''
                    aws ecr get-login-password --region $AWS_REGION |
                    docker login --username AWS --password-stdin $ECR_REGISTRY
                '''
            }
        }

        stage('Push Images to ECR') {
            steps {
                sh '''
                    docker tag user-service:latest $ECR_REGISTRY/user-service:v1
                    docker tag product-service:latest $ECR_REGISTRY/product-service:v1
                    docker tag order-service:latest $ECR_REGISTRY/order-service:v1

                    docker push $ECR_REGISTRY/user-service:v1
                    docker push $ECR_REGISTRY/product-service:v1
                    docker push $ECR_REGISTRY/order-service:v1
                '''
            }
        }
    }
}
