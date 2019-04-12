# openvpn-client

Docker OpenVPN Client

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/ccmpbll/openvpn-client.svg?style=flat-square) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/ccmpbll/openvpn-client.svg?style=flat-square) ![Docker Pulls](https://img.shields.io/docker/pulls/ccmpbll/openvpn-client.svg?style=flat-square) ![License](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square)

![](https://img.shields.io/static/v1.svg?label=Image&message=Alpine&color=blue&style=flat-square) ![Layers](https://img.shields.io/microbadger/layers/ccmpbll/openvpn-client/latest.svg?style=flat-square) ![Size](https://img.shields.io/microbadger/image-size/ccmpbll/openvpn-client/latest.svg?style=flat-square)

![](https://img.shields.io/static/v1.svg?label=Image&message=Ubuntu&color=blue&style=flat-square) ![Layers](https://img.shields.io/microbadger/layers/ccmpbll/openvpn-client/ubuntu.svg?style=flat-square) ![Size](https://img.shields.io/microbadger/image-size/ccmpbll/openvpn-client/ubuntu.svg?style=flat-square)


Docker container that supports many commercial OpenVPN providers and self-hosted OpenVPN servers. I wanted these images to be as small as possible, so no provider configuration files are included. You will need to provide them yourself.

Credit for original work goes to [jsloan117](https://hub.docker.com/r/jsloan117/docker-openvpn-client) and [haugene](https://github.com/haugene/docker-transmission-openvpn) - Thank you guys for hard work and making this easy for a noob.



## Run from Docker Hub

Place your *.ovpn file in `/some/path/providername`. 

```bash
$ docker run --cap-add=NET_ADMIN --device=/dev/net/tun -d --name openvpn_client \
-v /etc/localtime:/etc/localtime:ro \
-v /some/path:/etc/openvpn:rw \
-e OPENVPN_PROV=providername \
-e OPENVPN_CONF=config \
-e OPENVPN_USER=username \
-e OPENVPN_PASS=password \
-e OPENVPN_OPTS= \
-e LOCAL_NETWORK=10.10.1.0/24 \
-p 1194:1194 --dns 1.1.1.1 --dns 9.9.9.9 \
ccmpbll/openvpn-client

```

### Required Environment Variables

| Variable | Function | Example |
|----------|----------|-------|
| `OPENVPN_PROV` | VPN provider | `OPENVPN_PROV=provider` |
| `OPENVPN_CONF` | Config file to use | `OPENVPN_CONF=config` |
| `OPENVPN_USER` | VPN username | `OPENVPN_USER=username` |
| `OPENVPN_PASS` | VPN password | `OPENVPN_PASS=password` |
| `LOCAL_NETWORK` | Local network allowed across tunnel. Accepts comma separated list. | `LOCAL_NETWORK=10.10.1.0/24` |

### Optional Environment Variables

| Variable | Function | Example |
|----------|----------|-------|
| `OPENVPN_OPTS` | OpenVPN startup options | See [OpenVPN doc](https://openvpn.net/index.php/open-source/documentation/manuals/65-openvpn-20x-manpage.html) |


