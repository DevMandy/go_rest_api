pipeline {

    agent { label "master" }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage("Build Docker Image") {
            steps {
                sh '''docker build -t devmandy/go_rest_api:latest .'''
            }
        }

        stage("Push to DockerHub") {
            script {
                docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                    steps {
                        sh '''docker push devmandy/go_rest_api:latest'''
                    }
                }
            }
        }
    }
}