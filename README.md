# openvpn-client

![Image Build Status](https://img.shields.io/github/actions/workflow/status/ccmpbll/openvpn-client/docker-image.yml?branch=main) ![Docker Image Size](https://img.shields.io/docker/image-size/ccmpbll/openvpn-client/latest) ![Docker Pulls](https://img.shields.io/docker/pulls/ccmpbll/openvpn-client.svg) ![License](https://img.shields.io/badge/License-GPLv3-blue.svg)

A simple, easy to use Docker OpenVPN client that supports commercial OpenVPN providers and self-hosted OpenVPN servers. I wanted this image to be as small as possible, so no provider configuration files are included. You will need to provide them yourself.

Place your *.ovpn and auth files in `/some/path/`. The auth file can be named anything, but should be formatted like this:

```
myCoolUsername
mySuperSecretPassword
```

Once your files are in place, run the container:

```
$ docker run --cap-add=NET_ADMIN -d --name openvpn_client \
-v /some/path:/config:rw \
-e OPENVPN_CONF=config.ovpn \
-e OPENVPN_AUTH=auth.txt \
-e OPENVPN_OPTS= \
ccmpbll/openvpn-client
```

Please feel free to pass on any suggestions or feedback. 
