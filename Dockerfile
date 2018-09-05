FROM alpine:3.8
COPY golang_rest_api /go/bin/

CMD ["./service"]

EXPOSE 8123











