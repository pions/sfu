FROM golang:1.14.13-stretch

ENV GO111MODULE=on

WORKDIR $GOPATH/src/github.com/pion/ion

COPY go.mod go.sum ./
RUN cd $GOPATH/src/github.com/pion/ion && go mod download

COPY pkg/ $GOPATH/src/github.com/pion/ion/pkg
COPY cmd/ $GOPATH/src/github.com/pion/ion/cmd
COPY proto/ $GOPATH/src/github.com/pion/ion/proto

WORKDIR $GOPATH/src/github.com/pion/ion/cmd/islb
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /islb .

FROM alpine:3.14.0
RUN apk --no-cache add ca-certificates
COPY --from=0 /islb /usr/local/bin/islb

COPY configs/docker/islb.toml /configs/islb.toml

ENTRYPOINT ["/usr/local/bin/islb"]
CMD ["-c", "/configs/islb.toml"]
