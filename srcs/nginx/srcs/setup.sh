#!/bin/sh

if [ ! "$(ls -A /www)" ]
then
    echo "Initializing..."
    apk add openrc
    openrc boot
    rc-update add sshd
    /etc/init.d/sshd restart
    mv /index.html /www/.
else
    echo "Already initialized."
fi

nginx -g 'daemon off;'