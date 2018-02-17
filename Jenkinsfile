node("docker-enabled") {
    stage('Checkout') {
        checkout scm
    }
    stage("Build Docker Image") {
        sh '''docker build -t devmandy/go_rest_api:latest .'''
    }

    stage("Push to DockerHub") {
        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
            sh '''docker push devmandy/go_rest_api:latest'''
        }
    }
}
    