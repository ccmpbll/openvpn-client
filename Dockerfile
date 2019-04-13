FROM alpine:latest
LABEL Name=openvpn-client Version=0.1
LABEL maintainer="Chris Campbell"

RUN apk --no-cache --no-progress update && apk --no-cache --no-progress upgrade \
    && apk --no-cache --no-progress add bash tini openvpn shadow curl jq net-tools traceroute \
    && rm -rf /tmp/* /var/tmp/*

COPY openvpn/ /etc/openvpn/

ENV CONFIG_PATH="/config" \
    OPENVPN_CONF=NONE \
    OPENVPN_USER=NONE \
    OPENVPN_PASS=NONE \
    OPENVPN_OPTS= \
    LOCAL_NETWORK=10.10.1.0/24

VOLUME ["/config"]
ENTRYPOINT ["tini", "--", "/etc/openvpn/start.sh"]
