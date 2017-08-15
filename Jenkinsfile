#!groovy
@Library('jenkins-library') _

env.GITHUB_REPO="golang_rest_api"
env.PORT="8123"

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

    def ginkgo = docker.image("${env.DOCKERHUB_ORGANIZATION}/ginkgo:latest")
    docker.withRegistry('https://index.docker.io/v1/', "${DOCKERHUB_CREDENTIALS_ID}") {
        ginkgo.inside {

            stage("Run Tests") {

                echo "Run Tests"

                git branch: branch, credentialsId: "github", url: "git@github.com:devmandy/golang_rest_api.git"

                try {
                    currentBuild.result = 'SUCCESS'

                    goTest(env)

                } catch (e) {
                    step([$class: 'JUnitResultArchiver', testResults: '**/*.xml'])
                    echo "ERROR ${e}"
                    slackSend channel: "${env.SLACK_CHANNEL}", color: '#FF0000', message: "Unit tests have failed for ${env.GITHUB_REPO}", token: "${SLACK_TOKEN}"
                    currentBuild.result = 'FAILURE'
                    throw e
                }
            }

            stage("Build") {

                echo "Build"

                goBuild(env)
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

            slackSend channel: "${env.SLACK_CHANNEL}", color: '#FF0000', message: "Jenkins is waiting for authorization to deploy ${env.GITHUB_REPO} to production.", token: "${SLACK_TOKEN}"
            input message: 'Authorization required: Deploy to production?', ok: 'OK'

            try {

                configureTestEnv(env)
                dockerDeploy(env, "${DOCKERHUB_ORGANIZATION}/${env.GITHUB_REPO}", "${env.PORT}")

            } catch(e) {

                echo "Error: ${e}"
            }
        }
    }

    else{
        echo "Not pushing ${dockerModel.getImageName()} for ${branch} to docker hub because it is not a master branch."
        slackSend channel: "${env.SLACK_CHANNEL}", color: '#FF0000', message: "PR for ${env.GITHUB_REPO} passed quality checks.  Safe to squash and merge.", token: "${SLACK_TOKEN}"
    }

    if(isRelease) {
        stage("Tag Release in Github") {
            tagGithubCommit(github, tagger)
        }
    }

}
