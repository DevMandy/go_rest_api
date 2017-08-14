FROM golang:1.7.3-alpine
MAINTAINER Mandy Hubbard

RUN echo "@edge http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk add --update \
    bash \
rm -rf /var/cache/apk/*

RUN pwd
RUN ls -al
COPY cmd/golang_rest_api /go/bin/

CMD /go/bin/golang_rest_api

EXPOSE 8123





