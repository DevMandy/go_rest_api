pipeline {
    agent { label "master" }    //Run everything on an agent with the docker daemon
    stages {
        stage('Build') {
            
            agent {
                docker {
                    reuseNode true    //reuse the workspace on the agent defined at top-level\
                    image 'golang:1.10rc2-alpine3.7'
                    registryUrl 'https://index.docker.io/v1/'
                    registryCredentialsId 'dockerhub'
                }
            }
            steps {
              
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'git@github.com:DevMandy/go_rest_api.git']]])
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
