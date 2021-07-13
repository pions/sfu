FROM golang:1.16.6-stretch

ENV GO111MODULE=on

WORKDIR $GOPATH/src/github.com/pion/ion

COPY go.mod go.sum ./
RUN cd $GOPATH/src/github.com/pion/ion && go mod download

COPY pkg/ $GOPATH/src/github.com/pion/ion/pkg
COPY proto/ $GOPATH/src/github.com/pion/ion/proto
COPY apps $GOPATH/src/github.com/pion/ion/apps

WORKDIR $GOPATH/src/github.com/pion/ion/apps/biz
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /app-biz .

FROM alpine:3.12.1

RUN apk --no-cache add ca-certificates
COPY --from=0 /app-biz /usr/local/bin/app-biz

COPY configs/docker/app-biz.toml /configs/app-biz.toml

ENTRYPOINT ["/usr/local/bin/app-biz"]
CMD ["-c", "/configs/app-biz.toml"]
