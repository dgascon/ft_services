#!/bin/sh

cd /telegraf-1.15.2/usr/bin/ && ./telegraf &

if [ ! "$(ls -A /www)" ]
then
    echo "Initializing..."
    mv /index.html /www/.
else
    echo "Already initialized."
fi
/etc/init.d/sshd restart
nginx -g 'daemon off;'