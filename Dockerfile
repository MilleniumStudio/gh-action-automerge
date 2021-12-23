FROM alpine:latest

RUN apk --no-cache add bash git git-lfs

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
