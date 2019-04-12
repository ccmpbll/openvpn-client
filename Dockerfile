FROM alpine:latest
LABEL Name=openvpn-client Version=0.1
LABEL maintainer="Chris Campbell"

RUN apk update && apk upgrade \
    && apk --no-cache add bash dumb-init openvpn shadow curl jq \
    && rm -rf /tmp/* /var/tmp/*

COPY openvpn/ /etc/openvpn/

ENV OPENVPN_USER=**None** \
    OPENVPN_PASS=**None** \
    OPENVPN_PROV=**None** \
    OPENVPN_OPTS= \
    LOCAL_NETWORK=192.168.0.0/16

VOLUME /etc/openvpn
CMD ["dumb-init", "/etc/openvpn/start.sh"]
