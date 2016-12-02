#!groovy

def imageTag = "build-${env.BUILD_NUMBER}"
def imageName = 'homepay/golang_rest_seed'
def image


stage('Build source')
{
    echo "Building"
    node {


		sh '''#!/bin/bash
		set -x
		pwd
		cat $JENKINS_HOME/.gitconfig
		eval "$(ssh-agent -s)"
		echo $JENKINS_HOME
		ssh-add $JENKINS_HOME/.ssh/id_rsa_jenkins
		ssh-keyscan github.com >> /$JENKINS_HOME/.ssh/known_hosts
		export GOPATH="$JENKINS_HOME/workspace/$JOB_NAME"
		export GOBIN="$GOPATH/bin"

		go get github.com/onsi/ginkgo/ginkgo
        go get github.com/onsi/gomega

		go get -v github.com/MyHomePay/golang_rest_seed
        go build -v github.com/MyHomePay/golang_rest_seed

        mv $JENKINS_HOME/workspace/$JOB_NAME/golang_rest_seed $JENKINS_HOME/workspace/$JOB_NAME/src/github.com/MyHomePay/golang_rest_seed/
        '''

    }
}

stage('Run tests') {

    node {

        sh '''
        export GOPATH="$JENKINS_HOME/workspace/$JOB_NAME"
        export GOBIN="$GOPATH/bin"
        echo $GOPATH
        cd $JENKINS_HOME/workspace/$JOB_NAME/src/github.com/MyHomePay/golang_rest_seed
        go test
        '''

    }
}

docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {

	stage('Build Docker image') {
	    echo pwd()
		echo "Building docker image"

		dir('src/github.com/MyHomePay/golang_rest_seed') {
            image = docker.build("${imageName}:${imageTag}")
        }

	}

	stage('Push image to Docker Hub') {
		echo "Pushing image to Docker Hub"

		image.push();
		image.push('latest');
		}
}

stage('Deploy to Joyent') {

	node {
	    input message: 'Are you ready to deploy to Joyent?', ok: 'Hell yeah!'
	    sh '''
	    set -x
	    triton profile list
	    eval "$(triton env us-sw-1)"
	    docker info
        docker run -d --name golang_rest_seed -p 8123:8123 homepay/golang_rest_seed:latest'''
	}

}

stage('Notify') {
    slackSend color: 'purple', message: "${imageName}:${imageTag} built and deployed to Joyent"
}
