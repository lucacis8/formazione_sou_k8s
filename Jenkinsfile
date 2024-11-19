pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "lucacisotto/flask-app-example"
        DOCKER_TAG = "latest"  // Default tag, verrà sovrascritto successivamente
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
                    // Usa git per determinare il branch o il tag corrente
                    def gitBranch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    def isTag = sh(script: "git describe --exact-match --tags || echo ''", returnStdout: true).trim()

                    if (isTag) {
                        // Se è un tag Git, usa il tag per l'immagine Docker
                        env.DOCKER_TAG = isTag
                        echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                    } else if (gitBranch == "main") {
                        // Se è il branch main, usa "latest" come tag
                        env.DOCKER_TAG = "latest"
                        echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                    } else if (gitBranch == "develop") {
                        // Se è il branch develop, usa "develop" + sha come tag
                        def sha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                        env.DOCKER_TAG = "develop-${sha}"
                        echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                    } else {
                        // Se non è un tag né un branch conosciuto, usa SHA del commit
                        def sha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                        env.DOCKER_TAG = "unknown-${sha}"
                        echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Costruisci l'immagine Docker con il tag determinato
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', 
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
