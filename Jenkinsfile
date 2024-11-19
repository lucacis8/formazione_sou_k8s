pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'lucacisotto/flask-app-example'
    }
    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
        
        stage('Determine Tag') {
            steps {
                script {
                    def tag = "latest"
                    if (env.BRANCH_NAME == 'develop') {
                        tag = "develop"
                    } else if (env.BRANCH_NAME == 'main') {
                        tag = "main"
                    } else {
                        tag = "feature-${env.BRANCH_NAME}"
                    }
                    echo "Using tag: ${tag}"
                    env.DOCKER_TAG = tag
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${env.DOCKER_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${env.DOCKER_TAG}"
                    }
                }
            }
        }
    }
}
