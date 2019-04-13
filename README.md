# openvpn-client

Docker OpenVPN Client

![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/ccmpbll/openvpn-client.svg?style=flat-square) ![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/ccmpbll/openvpn-client.svg?style=flat-square) ![Docker Pulls](https://img.shields.io/docker/pulls/ccmpbll/openvpn-client.svg?style=flat-square) ![License](https://img.shields.io/badge/License-GPLv3-blue.svg?style=flat-square) ![Layers](https://img.shields.io/microbadger/layers/ccmpbll/openvpn-client/latest.svg?style=flat-square) ![Size](https://img.shields.io/microbadger/image-size/ccmpbll/openvpn-client/latest.svg?style=flat-square)

A simple, easy to use Docker OpenVPN client that supports commercial OpenVPN providers and self-hosted OpenVPN servers. I wanted this image to be as small as possible, so no provider configuration files are included. You will need to provide them yourself.

## Run from Docker Hub

Place your *.ovpn and auth files in `/some/path/`. The auth file can be named anything, but should be formatted like this:

```
myCoolUsername
mySuperSecretPassword
```

```bash
$ docker run --cap-add=NET_ADMIN -d --name openvpn_client \
-v /some/path:/config:rw \
-e OPENVPN_CONF=config.ovpn \
-e OPENVPN_AUTH=auth.txt \
-e OPENVPN_OPTS= \
ccmpbll/openvpn-client
```


I am open to suggestions and feedback, so let me know. Enjoy!
