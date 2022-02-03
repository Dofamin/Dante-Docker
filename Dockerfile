# OS
FROM ubuntu:latest
# Set version label
LABEL maintainer="github.com/Dofamin"
LABEL image="Dante-Socks5"
LABEL OS="Ubuntu/latest"
COPY container-image-root/ /
# ARG & ENV
ENV TZ=Europe/Moscow
# Update system packages:
RUN apt -y update > /dev/null 2>&1;\
# Fix for select tzdata region
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone > /dev/null 2>&1;\
    dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1;\
# Install dependencies, you would need common set of tools.
    apt -y install curl wget ntp logrotate > /dev/null 2>&1;\
# Install dante server.
    apt -y install dante-server > /dev/null 2>&1;\
    mkdir -p /Dante && mkdir -p /Dante/logrotate ;\
    (crontab -l 2>/dev/null; echo "0 0 * * * /usr/sbin/logrotate /Dante/logrotate/logrotate_sockd.conf >> /var/log/cron.log 2>&1") | crontab - ;\
# Cleanup
    apt-get clean > /dev/null 2>&1;
# Expose Ports:
EXPOSE 443/tcp 443/udp
# CMD
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
#CMD ["/bin/bash" , "-c" , "service ntp start && service cron start && /usr/sbin/danted -f /Dante/sockd.conf"]
