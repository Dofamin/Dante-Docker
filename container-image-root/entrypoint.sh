#!/bin/bash
set -x

if [ ! -f /Dante/sockd.conf ]; then
    cp /sockd.conf /Dante/sockd.conf
fi

if [ ! -f /Dante/Users.list.txt ]; then
    cp /Users.list.txt /Dante/Users.list.txt
fi

if [ ! -f /Dante/logrotate/logrotate_sockd.conf ]; then
    cp /logrotate_sockd.conf /Dante/logrotate/logrotate_sockd.conf
fi

function update_users() {
    while read -r line; do
        User=$(echo "$line" | awk -F":" '{print $1}')
        deluser "$User" >/dev/null 2>&1
        echo "$User deleted"
        delgroup "$User" >/dev/null 2>&1
    done </Dante/Users.list.txt
    while read -r line; do
        User=$(echo "$line" | awk -F":" '{print $1}')
        Password=$(echo "$line" | awk -F":" '{print $2}')
        useradd "$User" -M -s /sbin/nologin
        echo "${User}:$Password" | chpasswd
        echo "$User added"
    done </Dante/Users.list.txt
}

echo "Updating users."
update_users
service ntp start
service cron start
/usr/sbin/danted -f /Dante/sockd.conf
