pipeline {
    agent any

    environment {
        DOCKER_TAG = '' // Variabile Docker Tag inizializzata vuota
        DOCKER_IMAGE = 'my-flask-app' // Nome base dell'immagine Docker
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
                    // Ottieni il tag Git o imposta un valore predefinito
                    DOCKER_TAG = sh(script: "git describe --exact-match --tags || echo 'latest'", returnStdout: true).trim()
                    echo "Building Docker image with tag: ${DOCKER_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                    echo "Docker image built: ${dockerImage.id}"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_credentials') {
                        dockerImage.push("${DOCKER_TAG}")
                        echo "Docker image pushed with tag: ${DOCKER_TAG}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Build or push failed!"
        }
    }
}
