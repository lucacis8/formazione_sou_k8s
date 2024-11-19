pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "lucacisotto/flask-app-example"
        DOCKER_TAG = "" // Sarà determinato dinamicamente
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Determine Tag') {
            steps {
                script {
                    // Determina il branch o il tag corrente
                    def gitBranch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    def isTag = sh(script: "git describe --exact-match --tags || echo ''", returnStdout: true).trim()

                    if (isTag) {
                        env.DOCKER_TAG = isTag
                        echo "Building from Git tag: ${env.DOCKER_TAG}"
                    } else if (gitBranch == "master") {
                        env.DOCKER_TAG = "latest"
                        echo "Building from master branch: ${env.DOCKER_TAG}"
                    } else if (gitBranch == "develop") {
                        def sha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                        env.DOCKER_TAG = "develop-${sha}"
                        echo "Building from develop branch: ${env.DOCKER_TAG}"
                    } else {
                        error("Unsupported branch or tag: ${gitBranch}")
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Costruisce l'immagine Docker
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', 
                                                   usernameVariable: 'DOCKER_USERNAME', 
                                                   passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Esegui il login su Docker Hub
                        sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                        // Esegui il push dell'immagine Docker
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }
    }

    post {
        always {
            // Pulisce lo workspace dopo ogni build
            cleanWs()
        }

        success {
            echo "Build and push completed successfully!"
        }

        failure {
            echo "Build or push failed!"
        }
    }
}
