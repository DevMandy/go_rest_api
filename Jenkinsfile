#!groovy
@Library('jenkins-library') _

env.GITHUB_REPO = "golang_rest_api"
env.DOCKER_REPO = "golang_rest_api"

def github
def dockerModel
def tagger
def dotnet
def imageName
def tagComment

node("master") {

    github = new GithubModel(env)
    dockerModel = new DockerModel(env)
    tagger = new TaggerModel(env)
    tagger.setMessage(params.comment)
}


node("golang-jenkins-agent") {
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

    stage("Run Tests") {

        sh """
            export PATH=/go/bin:$PATH
            pwd
            ls
            cd cmd
            ginkgo
            
        """

    }
}
