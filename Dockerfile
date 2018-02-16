FROM golang:1.9.4-alpine3.7 AS build
WORKDIR /go/src/github.com/devmandy/go-rest-api
COPY service/* ./

RUN apk update && apk add git

RUN go get -u github.com/onsi/ginkgo/ginkgo && go get -u github.com/onsi/gomega/...

RUN go test
RUN go build service.go

#Production Docker image
FROM alpine:3.7
WORKDIR /root/
COPY --from=build /go/src/github.com/devmandy/go-rest-api/service .
CMD ["./service"]

EXPOSE 8123











