pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "lucacisotto/flask-app-example"
        DOCKER_TAG = "latest"  // Default tag
    }

    stages {
        stage('Checkout SCM') {
            steps {
                // Checkout del repository Git e recupero dei tag remoti
                checkout scm
                // Assicurati di recuperare anche i tag remoti
                sh "git fetch --tags"
            }
        }

        stage('Determine Tag') {
            steps {
                script {
                    // Determina il branch corrente
                    def gitBranch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    
                    // Controlla se il commit ha un tag esatto
                    def tags = sh(script: "git tag --points-at HEAD", returnStdout: true).trim()

                    if (tags) {
                        // Se il commit è associato a un tag, usa quel tag
                        env.DOCKER_TAG = tags
                        echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                    } else if (gitBranch == "main") {
                        // Se siamo sul branch main, usa "latest"
                        env.DOCKER_TAG = "latest"
                        echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                    } else if (gitBranch == "develop") {
                        // Se siamo sul branch develop, usa "develop" + sha
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
                        // Esegui il push dell'immagine Docker con il tag determinato
                        sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
