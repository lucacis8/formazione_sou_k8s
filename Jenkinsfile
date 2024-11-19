pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "lucacisotto/flask-app-example"
        DOCKER_TAG = "" // Sarà determinato dinamicamente
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
                    // Usa git per determinare il tag o il branch
                    def gitBranch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    def isTag = sh(script: "git describe --exact-match --tags || echo ''", returnStdout: true).trim()

                    // Determina il tag Docker in base al tipo di build
                    if (isTag) {
                        // Se è un tag Git, usa il tag come tag Docker
                        env.DOCKER_TAG = isTag
                        echo "Building Docker image with tag (from Git tag): ${env.DOCKER_TAG}"
                    } else if (gitBranch == "master") {
                        // Se è il branch master, usa "latest"
                        env.DOCKER_TAG = "latest"
                        echo "Building Docker image with tag (from master branch): ${env.DOCKER_TAG}"
                    } else if (gitBranch == "develop") {
                        // Se è il branch develop, usa "develop-<sha>"
                        def sha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                        env.DOCKER_TAG = "develop-${sha}"
                        echo "Building Docker image with tag (from develop branch): ${env.DOCKER_TAG}"
                    } else {
                        // Se non è un tag né un branch supportato, lancia un errore
                        error("Unsupported branch or tag: ${gitBranch}")
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
