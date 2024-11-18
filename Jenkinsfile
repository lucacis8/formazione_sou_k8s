pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "lucacisotto/flask-app-example"
        DOCKER_TAG = "v1.0"
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
                    // Usa git per determinare il tag
                    def tag = sh(script: "git describe --tags", returnStdout: true).trim()
                    env.DOCKER_TAG = tag
                    echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Costruisci l'immagine Docker
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', 
                                                   usernameVariable: 'DOCKER_USERNAME', 
                                                   passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Esegui il login su Docker Hub
                        sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                        // Esegui il push dell'immagine Docker
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }
    }

    post {
        always {
            // Pulisce lo workspace dopo ogni build
            cleanWs()
        }

        success {
            echo "Build and push completed successfully!"
        }

        failure {
            echo "Build or push failed!"
        }
    }
}
