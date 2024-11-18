pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'lucacisotto/flask-app-example'
        REGISTRY_CREDENTIALS = credentials('dockerhub-credentials')
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Determine Tag') {
            steps {
                script {
                    def gitTag = sh(script: 'git describe --tags --exact-match || echo ""', returnStdout: true).trim()
                    def branch = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                    def commit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    
                    if (gitTag) {
                        env.DOCKER_TAG = gitTag
                    } else if (branch == 'main') {
                        env.DOCKER_TAG = 'latest'
                    } else if (branch == 'develop') {
                        env.DOCKER_TAG = "develop-${commit}"
                    } else {
                        error("Unable to determine Docker tag. Please check the branch or tags.")
                    }
                    
                    echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', REGISTRY_CREDENTIALS) {
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
