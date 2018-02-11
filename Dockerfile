FROM golang:1.10.rc2-alpine37
MAINTAINER Mandy Hubbard

RUN echo "@edge http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk add --update \
    bash \
rm -rf /var/cache/apk/*

RUN pwd
RUN ls -al
COPY ./golang_rest_api /go/bin/

CMD /go/bin/golang_rest_api

EXPOSE 8123





