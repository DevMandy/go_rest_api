podTemplate(name: 'super-pod', label: 'super-pod', containers: [
        containerTemplate(name: 'golang', image: 'golang:1.9.4-alpine3.7', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'docker', image:'trion/jenkins-docker-client', ttyEnabled: true, command: 'cat'),
],
    volumes: [
            hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    ])
    {
    node("super-pod") {
        stage('Checkout') {
            checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'git@github.com:DevMandy/go_rest_api.git']]])

        }
        container("golang") {
            stage('Test'){
                sh '''
                    go get github.com/onsi/ginkgo/ginkgo
                    go get github.com/onsi/gomega
                    
                    go test
                '''
            }
            stage('Build') {
                sh '''
                    go build 
                '''
            }
        }
        container('docker'){
            stage('Docker Build') {
                sh '''
                    docker build -t devmandy/go_rest_api:latest .
                '''
            }
            stage('Docker Push') {
                docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
                    sh '''docker push devmandy/go_rest_api:latest'''
                }
            }
        }
    }
}

