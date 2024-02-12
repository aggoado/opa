FROM alpine:edge
ENV USERNAME="user" \
    PASSWORD="123" \
    SUDO_OK="true" \
    AUTOLOGIN="true" \
    TZ="Etc/UTC"

COPY ./entrypoint.sh /
COPY ./skel/ /etc/skel

RUN apk update && \
    apk add --no-cache tini bash ttyd tzdata sudo nano && \
    chmod 700 /entrypoint.sh && \
    touch /etc/.firstrun && \
    ln -s "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo $TZ > /etc/timezone 

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]

EXPOSE 7681/tcp
