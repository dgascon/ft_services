#!/bin/sh

cd /telegraf-1.15.2/usr/bin/ && ./telegraf &

influxd -config /etc/influxdb.conf
