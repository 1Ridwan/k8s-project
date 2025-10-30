# ---- build ----
FROM golang:1.23.6-alpine AS build

WORKDIR /src

RUN apk add --no-cache git

COPY go.mod go.sum ./

RUN go mod download

COPY . .

ENV CGO_ENABLED=0 GOOS=linux

RUN go build -trimpath -o /shiori .

# ---- run ----
FROM alpine:3.20

RUN apk add --no-cache ca-certificates tini

# non-root user + writable data dir

RUN adduser -D -H -u 10001 app \
 && mkdir -p /data \
 && chown -R app:app /data

WORKDIR /data

USER app

COPY --from=build /shiori /usr/local/bin/shiori

EXPOSE 8080

ENTRYPOINT ["/sbin/tini","-g","--"]

CMD ["shiori","server","--address","0.0.0.0","--port","8080","--storage-directory","/data"]
