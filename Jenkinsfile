pipeline {
    agent any

    environment {
        // Replace with your Docker Hub username or registry path
        DOCKER_REGISTRY = 'traversal99'
    }

    stages {
        stage('Checkout Source') {
            steps {
                // Clone your repository
                git url: 'https://github.com/AbhinavSingh93/Jenkprac', branch: 'master'
            }
        }

        stage('Build & Push Docker Images') {
            steps {
                script {
                    // Authenticate to Docker Registry using Jenkins credentials
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"

                        // Build the Docker image using docker-compose
                        sh "docker-compose build web"

                        // Tag the image with the build number
                        def imageTag = "${DOCKER_REGISTRY}/my-nodejs-app:${env.BUILD_NUMBER}"
                        sh "docker tag my-nodejs-app:latest ${imageTag}"

                        // Push the image to the registry
                        sh "docker push ${imageTag}"
                    }
                }
            }
        }

        stage('Deploy Multi-Container App') {
            steps {
                script {
                    // Stop and remove existing containers if they exist
                    sh "docker stop node-web node-mongo-db || true"
                    sh "docker rm node-web node-mongo-db || true"

                    // Deploy using docker-compose with updated image tag
                    sh "BUILD_NUMBER=${env.BUILD_NUMBER} docker-compose up -d --force-recreate"
                }
            }
        }
    }

    post {
        always {
            // Clean workspace after job finishes
            cleanWs()
        }
    }
}