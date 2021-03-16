## Dante-Docker

[**Dante**](http://www.inet.no/dante/index.html) consists of a SOCKS server and a SOCKS client, implementing RFC 1928 and related standards. It can in most cases be made transparent to clients, providing functionality somewhat similar to what could be described as a non-transparent Layer 4 router. For customers interested in controlling and monitoring access in or out of their network, the Dante SOCKS server can provide several benefits, including security and TCP/IP termination (no direct contact between hosts inside and outside of the customer network), resource control (bandwidth, sessions), logging (host information, data transferred), and authentication.

## Getting Started

* Change its configuration (see [sample config files](http://www.inet.no/dante/doc/latest/config/server.html)).

* Create list of users w/ passwords. (see [example](https://github.com/Dofamin/Dante-Docker/blob/main/container-image-root/Dante.list.txt)).

## Bulding

```shell
git clone https://github.com/Dofamin/Dante-Docker.git /srv/Dante/

docker build /srv/Dante/ --tag dante 

docker rm --force Dante

docker create \
  --name=Dante \
  -p 1010:443/tcp \
  -p 1010:443/udp \
  -v /srv/Dante/container-image-root/:/Dante/\
  --restart unless-stopped \
  dante:latest

docker start Dante
```

## Features

### Current Features

* Support for major platforms: Windows, Linux, macOS, Raspberry Pi, etc.
* Automatically detects new episodes
* Can scan your existing library and download any missing episodes
* Can watch for better quality of the episodes you already have and do an automatic upgrade. eg. from DVD to Blu-Ray
* Automatic failed download handling will try another release if one fails
* Manual search so you can pick any release or to see why a release was not downloaded automatically
* Fully configurable episode renaming
* Full integration with SABnzbd and NZBGet
* Full integration with Kodi, Plex (notification, library update, metadata)
* Full support for specials and multi-episode releases
* And a beautiful UI

---

### WARNING

 Many browsers do **not** support SOCKS authentication (e.g. see this [Chrome bug](https://bugs.chromium.org/p/chromium/issues/detail?id=256785)).
