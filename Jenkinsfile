pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "lucacisotto/flask-app-example"
        DOCKER_TAG = "latest"  // Default tag
    }

    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    // Checkout del repository Git
                    checkout scm
                    // Recuperiamo tutti i tag
                    sh "git fetch --tags"
                }
            }
        }

        stage('Determine Tag') {
            steps {
                script {
                    // Controlla se siamo su un tag
                    def tags = sh(script: "git tag --points-at HEAD", returnStdout: true).trim()
                    def gitBranch = sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    def sha = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()

                    echo "Current branch: ${gitBranch}"
                    echo "Tags associated with current commit: ${tags}"

                    // Se siamo su un tag, usiamo il tag
                    if (tags) {
                        env.DOCKER_TAG = tags
                        echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                    } else if (gitBranch == "main") {
                        // Se siamo su main, usa latest
                        env.DOCKER_TAG = "latest"
                        echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                    } else if (gitBranch == "develop") {
                        // Se siamo su develop, usa develop + sha
                        env.DOCKER_TAG = "develop-${sha}"
                        echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                    } else {
                        // Se non c'è tag e non siamo su main o develop, usa la sha
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
