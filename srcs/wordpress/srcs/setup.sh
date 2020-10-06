#!/bin/sh

cd /telegraf-1.15.2/usr/bin/ && ./telegraf &

php -S 0.0.0.0:5050 -t /www/