pipeline {

    agent { label "master" }
    stages {
        stage('Build') {
            agent {
                docker {
                    reuseNode true
                    image 'golang:1.10rc2-alpine3.7'
                    registryUrl 'https://index.docker.io/v1/'
                    registryCredentialsId 'dockerhub'
                }
            }
            steps {
                checkout scm
                sh '''go build -x cmd/hello_rest.go'''
            }
        }
        stage("Build Docker Image") {
            steps {
                sh '''docker build -t devmandy/go_rest_api:latest .'''
            }
        }
        stage("Push to DockerHub") {
            steps{
                sh '''docker push devmandy/go_rest_api:latest'''
            }
        }
    }
}