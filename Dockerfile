FROM golang:1.12-alpine AS builder
RUN apk add --no-cache git \
 && go get -v github.com/genuinetools/bane

FROM alpine:edge
COPY --from=builder /go/bin/bane /usr/bin/bane
RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
 && apk add --no-cache apparmor@testing \
 && ln -s /usr/sbin/apparmor_parser /sbin/
