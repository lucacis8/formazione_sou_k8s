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
                    def branch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    def commitSha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

                    // Recupero l'eventuale tag del commit
                    def commitTag = sh(script: "git describe --tags --exact-match", returnStdout: true).trim()

                    if (commitTag) {
                        // Se il commit ha un tag, uso quel tag
                        env.TAG = commitTag
                    } else if (branch == 'main') {
                        // Se siamo nel branch 'main', uso 'latest'
                        env.TAG = 'latest'
                    } else if (branch == 'develop') {
                        // Se siamo nel branch 'develop', uso 'develop-<sha>'
                        env.TAG = "develop-${commitSha}"
                    } else {
                        // In tutti gli altri branch, uso '<branch>-<sha>'
                        env.TAG = "${branch}-${commitSha}"
                    }

                    echo "Using tag: ${env.TAG}"
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
