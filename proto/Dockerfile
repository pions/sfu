FROM golang:1.14.13-stretch as builder

RUN go get github.com/golang/protobuf/protoc-gen-go
RUN export GO111MODULE=on && go get google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1.0

RUN echo $GOPATH

FROM alpine:3.14.0

RUN apk --no-cache add protobuf make

COPY --from=builder /go/bin/protoc-gen-go /usr/bin/
COPY --from=builder /go/bin/protoc-gen-go-grpc /usr/bin/

WORKDIR /workspace

ENTRYPOINT ["make"]