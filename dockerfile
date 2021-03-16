# OS
FROM centos:7
# Set version label
LABEL maintainer="github.com/Dofamin"
LABEL image=Dante-Socks5
LABEL OS=Centos7
COPY container-image-root/Dante.list.txt /
# Update system packages:
RUN yum -y update > /dev/null 2>&1;\
# Install dante server.
    yum -y install http://mirror.ghettoforge.org/distributions/gf/gf-release-latest.gf.el7.noarch.rpm > /dev/null 2>&1;\
    yum -y --enablerepo=gf-plus install dante-server > /dev/null 2>&1;\
    mkdir -p /Dante ;\
    while read line; do \
        User=$(echo $line| awk -F":" '{print $1}') ;\
        Password=$(echo $line| awk -F":" '{print $2}') ;\
        adduser $User -M -s /sbin/nologin ;\
        echo "$Password" | passwd $User --stdin;\
    done < /Dante.list.txt ;\
# Clean up
    yum -y autoremove > /dev/null 2>&1 ;\
    yum clean all > /dev/null 2>&1;\
    rm -rf /var/cache/yum > /dev/null 2>&1 
# Expose Ports:
EXPOSE 443/tcp 443/udp
# CMD
CMD ["/usr/sbin/sockd", "-f", "/Dante/sockd.conf"]