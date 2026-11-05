
pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-north-1'
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

        stage('Deploy to EC2') {
            steps {
                sh '''
                    docker rm -f user-service product-service order-service || true

                    docker run -d --restart unless-stopped \
                    --name user-service \
                    -p 5001:5001 \
                    $ECR_REGISTRY/user-service:v1

                    docker run -d --restart unless-stopped \
                    --name product-service \
                    -p 5002:5002 \
                    $ECR_REGISTRY/product-service:v1

                    docker run -d --restart unless-stopped \
                    --name order-service \
                    -p 5003:5003 \
                    $ECR_REGISTRY/order-service:v1
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    sleep 5
                    curl -f http://localhost:5001
                    curl -f http://localhost:5002
                    curl -f http://localhost:5003
                '''
            }
        }
    }
}

