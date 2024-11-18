pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = credentials('dockerhub-credentials') // Assicurati di avere le credenziali di DockerHub salvate in Jenkins
        REGISTRY_URL = "https://index.docker.io/v1/"
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
                    // Determina il tag da usare in base al branch o al tag Git
                    def tag
                    try {
                        // Controlliamo se esiste un tag Git
                        tag = sh(script: 'git describe --tags', returnStdout: true).trim()
                    } catch (Exception e) {
                        // Se non esiste un tag, prendiamo il branch e il commit hash
                        def branchName = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                        def shortCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()

                        if (branchName == 'master') {
                            tag = 'latest'
                        } else if (branchName == 'develop') {
                            tag = "develop-${shortCommit}"
                        } else {
                            tag = "HEAD-${shortCommit}"
                        }
                    }
                    env.TAG = tag
                    echo "Building Docker image with tag: ${env.TAG}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build dell'immagine Docker con il tag determinato
                    sh "docker build -t ${DOCKER_IMAGE}:${env.TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Pusha l'immagine Docker sul DockerHub con il tag
                    docker.withRegistry(REGISTRY_URL, DOCKER_CREDENTIALS) {
                        sh "docker push ${DOCKER_IMAGE}:${env.TAG}"
                        if (env.TAG == 'latest') {
                            sh "docker push ${DOCKER_IMAGE}:latest"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
