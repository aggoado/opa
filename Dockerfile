# base stage
FROM golang:1.20.4-alpine3.16 AS base

ARG GOPROXY

RUN apk add --update git ca-certificates build-base bash util-linux setpriv perl xz

# We are using libxcrypt to support yescrypt password hashing method
# Since libxcrypt package is not available in Alpine, so we need to build libxcrypt from source code
RUN wget -q https://github.com/besser82/libxcrypt/releases/download/v4.4.27/libxcrypt-4.4.27.tar.xz && \
    tar xvf libxcrypt-4.4.27.tar.xz && cd libxcrypt-4.4.27 && \
    ./configure --prefix /usr && make -j$(nproc) && make install && \
    cd .. && rm -rf libxcrypt-4.4.27*

RUN ln -sf /bin/bash /bin/sh

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub

COPY ./go.mod ./

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub/agent

COPY ./agent/go.mod ./agent/go.sum ./

RUN go mod download

# builder stage
FROM base AS builder

ARG SHELLHUB_VERSION=latest
ARG GOPROXY

COPY ./pkg $GOPATH/src/github.com/shellhub-io/shellhub/pkg
COPY ./agent .

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub

RUN go mod download

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub/agent

RUN go build -tags docker -ldflags "-X main.AgentVersion=${SHELLHUB_VERSION}"

# To avoid use $GOPATH on the `production` stage, we copy whe agent binary to /app on the root.
COPY ./agent /app/

# development stage
FROM base AS development

ARG GOPROXY
ENV GOPROXY ${GOPROXY}

RUN apk add --update openssl openssh-client
RUN go install github.com/markbates/refresh@v1.11.1 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.53.3

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub

RUN go mod download

#RUN cp -a $GOPATH/src/github.com/shellhub-io/shellhub/vendor /vendor

COPY ./agent/entrypoint-dev.sh /entrypoint.sh

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub/agent

ENTRYPOINT ["/entrypoint.sh"]

# production stage
FROM alpine:3.16 AS production

# Copy the libcrypt from builder stage to avoid rebuild it.
COPY --from=builder /usr/lib/libcrypt.so.* /usr/lib/

WORKDIR /app
COPY --from=builder /app/ /app/

ENTRYPOINT ./agent
