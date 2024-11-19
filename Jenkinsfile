pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "lucacisotto/flask-app-example"
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
                    // Ottieni l'ultimo tag Git disponibile (se esiste)
                    def gitTag = sh(script: 'git describe --tags --abbrev=0 || echo ""', returnStdout: true).trim()
                    // Ottieni il nome del branch
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

                    // Determina il tag dell'immagine Docker
                    def tag = ""
                    def additionalTag = ""

                    if (gitTag && gitTag != "") {
                        tag = gitTag
                        additionalTag = "latest"
                    } else if (branch == "main") {
                        tag = "latest"
                    } else if (branch == "develop") {
                        tag = "develop-${commitSha}"
                    } else {
                        tag = "${branch}-${commitSha}"
                    }

                    // Imposta il tag nell'ambiente
                    env.TAG = tag
                    env.ADDITIONAL_TAG = additionalTag

                    echo "Using tag: ${env.TAG}"
                    if (env.ADDITIONAL_TAG) {
                        echo "Additional tag: ${env.ADDITIONAL_TAG}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${env.TAG} ."
                    if (env.ADDITIONAL_TAG) {
                        sh "docker tag ${DOCKER_IMAGE}:${env.TAG} ${DOCKER_IMAGE}:${env.ADDITIONAL_TAG}"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        sh "docker push ${DOCKER_IMAGE}:${env.TAG}"
                        if (env.ADDITIONAL_TAG) {
                            sh "docker push ${DOCKER_IMAGE}:${env.ADDITIONAL_TAG}"
                        }
                    }
                }
            }
        }
    }
}
