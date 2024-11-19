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
                    // Recupera il tag del commit, se esiste
                    def gitTag = sh(script: 'git describe --tags --exact-match || echo ""', returnStdout: true).trim()
                    // Ottieni il nome del branch
                    def branch = sh(script: "git symbolic-ref --short HEAD || echo 'detached'", returnStdout: true).trim()
                    // Ottieni l'SHA abbreviato del commit
                    def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

                    // Determina il tag Docker
                    if (gitTag) {
                        // Usa il tag Git come tag dell'immagine
                        env.TAG = gitTag
                    } else if (branch == "main") {
                        // Usa "latest" per il branch "main"
                        env.TAG = "latest"
                    } else if (branch == "develop") {
                        // Usa "develop-<sha>" per il branch "develop"
                        env.TAG = "develop-${commitSha}"
                    } else if (branch == "detached") {
                        // Gestisce lo stato 'detached HEAD'
                        env.TAG = "detached-${commitSha}"
                    } else {
                        // Usa "<branch>-<sha>" per tutti gli altri branch
                        env.TAG = "${branch}-${commitSha}"
                    }

                    echo "Using Docker image tag: ${env.TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${env.TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                        sh "docker push ${DOCKER_IMAGE}:${env.TAG}"
                    }
                }
            }
        }
    }
}
