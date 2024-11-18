pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "lucacisotto/flask-app-example"
        DOCKER_TAG = "v1.0"
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
                    // Usa git per determinare il tag
                    def tag = sh(script: "git describe --tags", returnStdout: true).trim()
                    env.DOCKER_TAG = tag
                    echo "Building Docker image with tag: ${env.DOCKER_TAG}"
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login a Docker Hub utilizzando le credenziali di Jenkins
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }

        stage('Check and Create Docker Repository') {
            steps {
                script {
                    // Verifica se il repository esiste già su Docker Hub usando l'API
                    def repoCheck = sh(script: """
                        curl -s -u \$DOCKER_USERNAME:\$DOCKER_PASSWORD https://hub.docker.com/v2/repositories/\$DOCKER_USERNAME/\$DOCKER_IMAGE/ > response.json
                        jq -e .results > /dev/null 2>&1 < response.json
                        echo \$?
                    """, returnStdout: true).trim()

                    // Se il repository non esiste (exit code 1), crealo
                    if (repoCheck == '1') {
                        echo "Repository does not exist, creating it."
                        sh """
                            curl -X POST -u \$DOCKER_USERNAME:\$DOCKER_PASSWORD \
                            -H "Content-Type: application/json" \
                            -d '{"name": "\$DOCKER_IMAGE"}' \
                            https://hub.docker.com/v2/repositories/
                        """
                    } else {
                        echo "Repository already exists."
                    }
                }
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Funzione per costruire e fare il push dell'immagine Docker
                    def buildAndPushTag = { Map args ->
                        def defaults = [
                            registryUrl: 'https://index.docker.io/v1/',  // URL del registro Docker, come Docker Hub
                            dockerfileDir: "./",
                            dockerfileName: "Dockerfile",
                            buildArgs: "",
                            pushLatest: true
                        ]
                        args = defaults + args
                        docker.withRegistry(args.registryUrl) {
                            def image = docker.build(args.image, "${args.buildArgs} ${args.dockerfileDir} -f ${args.dockerfileName}")
                            image.push(args.buildTag)
                            if (args.pushLatest) {
                                image.push("latest")
                                sh "docker rmi --force ${args.image}:latest"
                            }
                            sh "docker rmi --force ${args.image}:${args.buildTag}"
                            return "${args.image}:${args.buildTag}"
                        }
                    }

                    // Chiamata alla funzione con i parametri specifici per la build e il push
                    buildAndPushTag(
                        image: "${DOCKER_IMAGE}",       // Nome dell'immagine Docker
                        buildTag: "${DOCKER_TAG}",      // Tag dell'immagine Docker
                        buildArgs: "",                 // Argomenti di build, se necessari
                        pushLatest: true               // Se fare anche il push dell'immagine con tag "latest"
                    )
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
