# OS
FROM ubuntu:latest
# Set version label
LABEL maintainer="github.com/Dofamin"
LABEL image="Dante-Socks5"
LABEL OS="Ubuntu/latest"
COPY container-image-root/Dante.list.txt /
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
    mkdir -p /Dante ;\
    while read line; do \
        User=$(echo $line| awk -F":" '{print $1}') ;\
        Password=$(echo $line| awk -F":" '{print $2}') ;\
        adduser $User -M -s /sbin/nologin ;\
        echo "$Password" | passwd $User --stdin;\
    done < /Dante.list.txt ;\
    (crontab -l 2>/dev/null; echo "0 0 * * * /usr/sbin/logrotate /Dante/logrotate/logrotate_sockd.conf >> /var/log/cron.log 2>&1") | crontab - ;\
# Cleanup
    apt-get clean > /dev/null 2>&1;
# Expose Ports:
EXPOSE 443/tcp 443/udp
# CMD
CMD ["/bin/bash" , "-c" , "service ntp start && service cron start && /usr/sbin/sockd -f /Dante/sockd.conf"]
