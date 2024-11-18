pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // ID credenziali DockerHub configurate in Jenkins
        DOCKER_IMAGE_NAME = 'lucacisotto/flask-app-example' // Nome immagine su DockerHub
    }
    stages {
        stage('Checkout') {
            steps {
                // Clona il repository da GitHub
                checkout scm
            }
        }
        stage('Determine Tag') {
            steps {
                script {
                    // Determina il tag dell'immagine in base al branch o al tag Git
                    def gitTag = sh(returnStdout: true, script: 'git describe --tags --exact-match || echo ""').trim()
                    def branch = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
                    def commitSha = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()

                    if (gitTag) {
                        env.IMAGE_TAG = gitTag
                    } else if (branch == 'main') {
                        env.IMAGE_TAG = 'latest'
                    } else if (branch == 'develop') {
                        env.IMAGE_TAG = "develop-${commitSha}"
                    } else {
                        env.IMAGE_TAG = "${branch}-${commitSha}"
                    }

                    echo "Building Docker image with tag: ${env.IMAGE_TAG}"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Costruisci l'immagine Docker
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${env.IMAGE_TAG} ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Pubblica l'immagine su DockerHub
                    docker.withRegistry('', DOCKER_CREDENTIALS_ID) {
                        sh "docker push ${DOCKER_IMAGE_NAME}:${env.IMAGE_TAG}"
                        // Pubblica il tag "latest" solo se il branch è main
                        if (env.IMAGE_TAG == 'latest') {
                            sh "docker tag ${DOCKER_IMAGE_NAME}:${env.IMAGE_TAG} ${DOCKER_IMAGE_NAME}:latest"
                            sh "docker push ${DOCKER_IMAGE_NAME}:latest"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            // Pulisci i file di lavoro dopo ogni build
            cleanWs()
        }
    }
}
