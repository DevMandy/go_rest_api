#!groovy
@Library('jenkins-library') _

env.GITHUB_REPO = "golang_rest_api"
env.DOCKER_REPO = "devmandy"
env.COMPOSE_PROJECT_NAME="golang_rest_api"
def repo="golang_rest_api"

def github
def dockerModel
def tagger
def imageName
def tagComment

node("master") {

    privateKey = env.PRIVATE_KEY
    github = new GithubModel(env)
    dockerModel = new DockerModel(env)
    tagger = new TaggerModel(env)
    tagger.setMessage(params.comment)

    def isRelease = isReleaseBranchSet(params)
    def branch = isRelease ? params.releaseBranch : env.BRANCH_NAME
    def pushToDocker = isRelease || branch == "master"
    def isPullRequest = !pushToDocker

    stage("Checkout") {
        if(isPullRequest) {
            echo "Building a PR or non-master branch that is not a release"
            checkout scm
        } else {
            echo "Doing a release or building master"
            git branch: branch, credentialsId: github.credentialsId, url: "git@github.com:${github.getOrganization()}/${github.getRepo()}.git"
        }
        github.setCommit(getGitCommit())
        tagger.setTag(getVersion())
    }

    stage("Tag Generation") {
        isGithubTagAvailable(isRelease, github, tagger)
    }

    def tag = isRelease ? tagger.getTag() : getSemver(branch)

    def ginkgo = docker.image("${docker_repo}/ginkgo:latest")
    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub') {
        ginkgo.inside {

            stage("Run Tests") {

                echo "Run Tests"

                sh '''

                set -x

                # ssh setup for git
                eval "$(ssh-agent -s)"
                ssh-add /var/jenkins_home/.ssh/triton
                mkdir -p ~/.ssh
                ssh-keyscan -H -t rsa github.com  >> ~/.ssh/known_hosts
                git config --global url."git@github.com:".insteadOf "https://github.com/"

                '''

                git branch: branch, credentialsId: "github", url: "git@github.com:devmandy/golang_rest_api.git"

                try {
                    currentBuild.result = 'SUCCESS'
                    sh """
						cd cmd 
                        ls -al                       
						go test -o ${repo} ./...


                    """
                } catch (e) {
                    step([$class: 'JUnitResultArchiver', testResults: '**/*.xml'])
                    echo "ERROR ${e}"
                    //slackSend channel: '#platform-builds', color: '#FF0000', message: "Unit tests failed.", token: 'slack3'
                    currentBuild.result = 'FAILURE'
                    throw e
                }
            }

            stage("Build") {

                echo "Build"

                sh """
                pwd
                cd cmd
                
				go build -o ${repo} ./...
                
                """

            }

        }

        stage("Build Docker Image") {

            echo "Build Docker Image"

            docker.withRegistry(dockerModel.getRegistry(), dockerModel.getCredentialsId()) {
                configureBuildEnv(dockerModel)
                dockerBuild(dockerModel, tag, "latest")

            }
        }

    }

    if(pushToDocker) {
        stage("Push to Docker Hub") {
            docker.withRegistry(dockerModel.getRegistry(), dockerModel.getCredentialsId()) {
                dockerPush(dockerModel, tag, "latest")
            }
        }

        stage('Deploy to Production') {

            input message: 'Authorization required: Deploy to production?', ok: 'OK'

            try {

                configureTestEnv(env)
                dockerDeploy(props, "devmandy/golang_rest_api", "8123")

            } catch(e) {

                echo "Error: ${e}"
            }
        }
    }

    else{
        echo "Not pushing ${dockerModel.getImageName()} for ${branch} to docker hub because it is not a master branch."
    }

    if(isRelease) {
        stage("Tag Release in Github") {
            tagGithubCommit(github, tagger)
        }
    }

}
