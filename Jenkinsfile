podTemplate(label: 'super-pod',
        containers: [
                containerTemplate(
                        name: 'jnlp',
                        image: 'jenkinsci/jnlp-slave:3.10-1-alpine',
                ),
                containerTemplate(
                        name: 'golang',
                        image: 'golang:1.11.0-alpine3.8',
                        command: 'cat',
                        ttyEnabled: true
                ),
                containerTemplate(
                        name: 'docker',
                        image: 'trion/jenkins-docker-client',
                        command: 'cat',
                        ttyEnabled: true
                ),
        ],
        volumes: [
                hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
        ]
)
        {
            node ('super-pod') {

                stage ('Checkout') {
                    checkout scm

                }

                stage ('Go Build') {
                    container('golang') {
                        sh '''
		    cd service
		    go build
		    ls
		'''
                    }
                }

                stage ('Docker Build') {
                    container('docker') {
                        sh '''
                ls
                docker build -t devmandy/go_rest_api:latest .
            '''
                    }
                }
            }
        }