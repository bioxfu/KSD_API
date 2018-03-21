# Version: 0.0.1
FROM golang:latest
MAINTAINER bio.xfu@gmail.com

WORKDIR /go
COPY . .

RUN apt-get update
RUN apt-get install -y sqlite3 libsqlite3-dev
RUN go get -d -v github.com/bioxfu/go-ksd
RUN export GOBIN=/go/bin; go install -v src/github.com/bioxfu/go-ksd/main.go

CMD ["main"]

