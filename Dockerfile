FROM alpine:latest
LABEL Name=openvpn-client Version=0.1
LABEL maintainer="Chris Campbell"

RUN apk --no-cache --no-progress update && apk --no-cache --no-progress upgrade \
    && apk --no-cache --no-progress add bash curl jq openvpn shadow tini \
    && rm -rf /tmp/* /var/tmp/*

COPY openvpn_start.sh /etc/openvpn/

ENV CONFIG_PATH="/config" \
    OPENVPN_CONF=NONE \
    OPENVPN_AUTH=NONE \
    OPENVPN_OPTS=

VOLUME ["/config"]
ENTRYPOINT ["tini", "--", "/etc/openvpn/openvpn_start.sh"]
