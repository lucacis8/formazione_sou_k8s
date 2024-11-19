pipeline {
    agent any

    environment {
        DOCKER_REPO = "lucacisotto/flask-app-example"
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
                    // Determina il tag Git, il branch corrente e il commit SHA
                    def gitTag = sh(script: "git describe --tags --exact-match || echo 'no-tag'", returnStdout: true).trim()
                    def gitBranch = sh(script: "git symbolic-ref --short HEAD || echo 'detached'", returnStdout: true).trim()
                    def gitCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

                    if (gitTag != 'no-tag') {
                        // Usa il tag Git esatto se disponibile
                        env.IMAGE_TAG = gitTag
                    } else if (gitBranch == 'main' || gitBranch == 'master') {
                        // Usa 'latest' per il branch main o master
                        env.IMAGE_TAG = "latest"
                    } else {
                        // Usa il nome del branch e SHA per altri branch
                        env.IMAGE_TAG = "${gitBranch}-${gitCommit}"
                    }

                    // Stampa i tag generati
                    echo "Using Docker image tag: ${env.IMAGE_TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build dell'immagine principale
                    sh "docker build -t ${DOCKER_REPO}:${env.IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Login Docker
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USER --password-stdin"

                        // Push del tag principale
                        sh "docker push ${DOCKER_REPO}:${env.IMAGE_TAG}"
                    }
                }
            }
        }
    }
}
