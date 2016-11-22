FROM golang:1.7.3-alpine
MAINTAINER Mandy Hubbard

RUN echo "@edge http://dl-4.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk add --update \
    bash \
rm -rf /var/cache/apk/*

COPY ./hello_rest /go/bin/

CMD /go/bin/hello_rest

EXPOSE 8123





