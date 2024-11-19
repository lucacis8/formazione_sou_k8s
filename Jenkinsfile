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
                    // Determina tag Git e branch corrente
                    def gitTag = sh(script: "git describe --tags --exact-match || echo 'no-tag'", returnStdout: true).trim()
                    def gitBranch = sh(script: "git symbolic-ref --short HEAD || echo 'detached'", returnStdout: true).trim()
                    def gitCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

                    if (gitTag != 'no-tag') {
                        // Usa il tag Git esatto se disponibile
                        env.IMAGE_TAG = gitTag
                    } else if (gitBranch == 'main') {
                        // Usa 'latest' e SHA per il branch main
                        env.IMAGE_TAG = "latest"
                        env.ADDITIONAL_TAG = "main-${gitCommit}"
                    } else {
                        // Usa il nome del branch e SHA per altri branch
                        env.IMAGE_TAG = "${gitBranch}-${gitCommit}"
                    }

                    echo "Using Docker image tag: ${env.IMAGE_TAG}"
                    if (env.ADDITIONAL_TAG) {
                        echo "Using additional tag: ${env.ADDITIONAL_TAG}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build dell'immagine principale
                    sh "docker build -t ${DOCKER_REPO}:${env.IMAGE_TAG} ."

                    // Build con tag aggiuntivo, se definito
                    if (env.ADDITIONAL_TAG) {
                        sh "docker tag ${DOCKER_REPO}:${env.IMAGE_TAG} ${DOCKER_REPO}:${env.ADDITIONAL_TAG}"
                    }
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

                        // Push del tag aggiuntivo, se definito
                        if (env.ADDITIONAL_TAG) {
                            sh "docker push ${DOCKER_REPO}:${env.ADDITIONAL_TAG}"
                        }
                    }
                }
            }
        }
    }
}
