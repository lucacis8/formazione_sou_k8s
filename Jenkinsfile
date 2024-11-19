pipeline {
    agent any
    environment {
        GIT_BRANCH_NAME = '' // Variabile per memorizzare il nome del branch
    }
    stages {
        stage('Checkout SCM') {
            steps {
                checkout scm
                script {
                    // Memorizza il nome del branch corrente
                    GIT_BRANCH_NAME = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                }
            }
        }
        
        stage('Determine Tag') {
            steps {
                script {
                    // Controlla se il branch è "main", se sì, usa "latest"
                    def tag = ''
                    if (GIT_BRANCH_NAME == 'main') {
                        tag = "latest"
                    } else {
                        // Per altre branch, usa il nome del branch
                        tag = "${GIT_BRANCH_NAME}-${env.GIT_COMMIT.take(7)}"
                    }
                    // Imposta il tag Docker
                    echo "Using Docker image tag: ${tag}"
                    env.DOCKER_TAG = tag
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Costruisci l'immagine Docker con il tag corretto
                    sh "docker build -t lucacisotto/flask-app-example:${env.DOCKER_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Login su Docker
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                        // Push dell'immagine Docker
                        sh "docker push lucacisotto/flask-app-example:${env.DOCKER_TAG}"
                    }
                }
            }
        }
    }
}
