#!groovy

def imageTag = "build-${env.BUILD_NUMBER}"
def imageName = 'homepay/hello_rest'
def image


stage('Checkout')
{
    echo "Checkout source"
    node {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], browser: [$class: 'GithubWeb', repoUrl: ''],
        doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs:
        [[credentialsId: 'mandyhubbard23 with password', url: 'https://github.com/MyHomePay/golang_rest_seed']]])
    }
}


stage('Build source')
{
    echo "Building"
    node {
        sh '''#!/bin/bash
        set -x
        export GOPATH=`pwd`
        export GOBIN="$GOPATH/bin"

        go get -v github.com/MyHomePay/hello_rest
        go build -v github.com/MyHomePay/hello_rest'''

    }
}

    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {

	stage('Build Docker image') {
	    echo "Building docker image"
		image = docker.build("${imageName}:${imageTag}")
	}

	stage('Push image to Docker Hub') {
	    echo "Pushing image to Docker Hub"

  		image.push();
  		image.push('latest');
		}
	}

stage('Deploy to Joyent') {

	node {
	    sh '''eval "$(triton env)"
        docker run -d --name hello_rest -p 8123:8123 homepay/hello_rest:latest'''
	}

}

stage('Notify') {
    slackSend color: 'purple', message: "${imageName}:${imageTag} built and deployed to Joyent"
}
