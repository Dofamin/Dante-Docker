#!/bin/bash
git clone https://github.com/Dofamin/Dante-Docker.git /srv/Dante/

docker build /srv/Dante/ --tag dante 

docker rm --force Dante

docker create \
  --name=Dante \
  -p 1010:443/tcp \
  -p 1010:443/udp \
  -v /srv/Dante/container-image-root/:/Dante/\
  -v /srv/Dante/container-image-root/logrotate/:/etc/logrotate.d/\
  --restart unless-stopped \
  dante:latest

docker start Dante
