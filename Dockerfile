FROM alpine:3.8
WORKDIR /usr/local/bin
COPY service .

CMD ["./service"]

EXPOSE 8123











