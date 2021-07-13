FROM golang:1.16.6-stretch

ENV GO111MODULE=on

WORKDIR $GOPATH/src/github.com/pion/ion

COPY go.mod go.sum ./
RUN cd $GOPATH/src/github.com/pion/ion && go mod download

COPY pkg/ $GOPATH/src/github.com/pion/ion/pkg
COPY cmd/ $GOPATH/src/github.com/pion/ion/cmd
COPY proto/ $GOPATH/src/github.com/pion/ion/proto

WORKDIR $GOPATH/src/github.com/pion/ion/cmd/signal
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /signal .

FROM alpine:3.12.1

RUN apk --no-cache add ca-certificates
COPY --from=0 /signal /usr/local/bin/signal

COPY configs/docker/signal.toml /configs/signal.toml

ENTRYPOINT ["/usr/local/bin/signal"]
CMD ["-c", "/configs/signal.toml"]
