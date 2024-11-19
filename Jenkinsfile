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
                    // Estrai il tag associato al commit corrente
                    def tags = sh(script: "git tag --points-at HEAD", returnStdout: true).trim()
                    if (tags) {
                        env.DOCKER_TAG = tags // Usa il tag associato al commit
                    } else {
                        env.DOCKER_TAG = "latest" // Se non ci sono tag, usa latest
                    }
                    echo "Tags associated with current commit: ${tags}"
                    echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Costruisci l'immagine Docker con il tag corretto
                    sh "docker build -t ${DOCKER_IMAGE}:${env.DOCKER_TAG} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Login a Docker Hub
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}"
                        // Pusha l'immagine Docker con il tag corretto
                        sh "docker push ${DOCKER_IMAGE}:${env.DOCKER_TAG}"
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
