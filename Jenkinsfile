pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'traversal99'
    }

    stages {
        stage('Checkout Source') {
            steps {
                git url: 'https://github.com/AbhinavSingh93/Jenkprac', branch: 'master'
            }
        }

        stage('Build & Push Docker Images') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )]) {
                        bat '''
                        echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin
                        docker-compose build web
                        docker tag app:latest traversal99/app:%BUILD_NUMBER%
                        docker push traversal99/app:%BUILD_NUMBER%
                        '''
                    }
                }
            }
        }

        stage('Deploy Multi-Container App') {
            steps {
                script {
                    bat '''
                    docker stop node-web node-mongo-db || exit 0
                    docker rm node-web node-mongo-db || exit 0
                    set BUILD_NUMBER=%BUILD_NUMBER%
                    docker-compose up -d --force-recreate
                    '''
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