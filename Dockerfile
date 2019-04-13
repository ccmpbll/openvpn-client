FROM alpine:latest
LABEL Name=openvpn-client Version=0.1
LABEL maintainer="Chris Campbell"

RUN apk update && apk upgrade \
    && apk --no-cache add bash dumb-init openvpn shadow curl jq \
    && rm -rf /tmp/* /var/tmp/*

COPY openvpn/ /etc/openvpn/

ENV CONFIG_PATH="/config" \
    OPENVPN_CONF=NONE \
    OPENVPN_USER=NONE \
    OPENVPN_PASS=NONE \
    OPENVPN_OPTS= \
    LOCAL_NETWORK=10.10.1.0/24

VOLUME /config
CMD ["dumb-init", "/etc/openvpn/start.sh"]
