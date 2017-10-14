# golang_rest_api
Test2
This is a reference project for creating a REST API in Go.

## Pre-Reqs
Make sure Go is installed and your `PATH` variable contains `%GOPATH%/bin`

## Usage:

### Jenkins Build
This project is intended to be built and deployed using the Jenkinsfile.

1.  Select `New Item` to create a new job
2.  Enter a name and select Pipeline as the project type
3.  Check the box next to GitHub project on the General tab
4.  Enter `https://github.com/MyHomePay/golang_rest_seed/` for the Project url
5.  Select Pipeline script from SCM for the Pipeline Definition under Advance Project Options
6.  Select Git for the SCM
7.  Enter `https://github.com/MyHomePay/golang_rest_seed/` for the Repository URL
8.  Select Credentials: TBD
9.  Click Save
10. Click Build Now

Jenkins will checkout the repository and build and deploy it to Joyent based on the build instructions in the Jenkinsfile.

### Run
1. From the Jenkins host, run `eval $(triton env)`
2. Execute `docker ps` to get the container ID for hello_rest
3. Execute `docker inspect <containerID>` to get the IP address of the deployed container
4. Open `http://<IPAddress>:8123` in a web browser

### Build Locally
Execute `go build github.com/MyHomePay/hello_rest`

### Run locally
Open `http://localhost:8123` in a web browser

### Test
A ginkgo test is run by this build and produces a junit.xml file.

# golang_rest_api
golang_rest_api
