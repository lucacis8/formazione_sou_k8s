pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'lucacisotto/flask-app-example' // Nome dell'immagine Docker
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
                    // Ottieni il nome del branch
                    def branch = env.BRANCH_NAME
                    def sha = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    
                    // Imposta il tag
                    if (branch == 'develop') {
                        env.DOCKER_TAG = "develop-${sha}"
                    } else {
                        env.DOCKER_TAG = "latest"
                    }
                    
                    echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Costruisci l'immagine Docker con il tag calcolato
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    script {
                        // Esegui il login su DockerHub
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                        
                        // Push dell'immagine Docker con il tag
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }
    }
}
