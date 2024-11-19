pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = "docker.io"
        DOCKER_REPO = "lucacisotto/flask-app-example"
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([$class: 'GitSCM', 
                          branches: [[name: '*/main']], 
                          userRemoteConfigs: [[url: 'https://github.com/lucacis8/formazione_sou_k8s', 
                          credentialsId: 'github-credentials']]
                ])
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
                        // Usa 'latest'
                        env.IMAGE_TAG = "latest"
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
                    sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_REPO}:${env.IMAGE_TAG} ."

                    // Build con tag aggiuntivo, se definito
                    if (env.ADDITIONAL_TAG) {
                        sh "docker tag ${DOCKER_REGISTRY}/${DOCKER_REPO}:${env.IMAGE_TAG} ${DOCKER_REGISTRY}/${DOCKER_REPO}:${env.ADDITIONAL_TAG}"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([string(credentialsId: 'dockerhub-password', variable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Login Docker
                        sh "echo $DOCKER_PASSWORD | docker login -u ${env.DOCKER_USER} --password-stdin"

                        // Push del tag principale
                        sh "docker push ${DOCKER_REGISTRY}/${DOCKER_REPO}:${env.IMAGE_TAG}"

                        // Push del tag aggiuntivo, se definito
                        if (env.ADDITIONAL_TAG) {
                            sh "docker push ${DOCKER_REGISTRY}/${DOCKER_REPO}:${env.ADDITIONAL_TAG}"
                        }
                    }
                }
            }
        }
    }
}
