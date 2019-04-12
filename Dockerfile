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
    LOCAL_NETWORK=10.10.1.0/24

VOLUME /etc/openvpn
CMD ["dumb-init", "/etc/openvpn/start.sh"]
