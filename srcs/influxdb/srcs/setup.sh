#!/bin/sh

# Check if mysql is installed
influxd & until influx -execute exit </dev/null >/dev/null 2>&1; do sleep 0.2; echo -n '.'; done; echo
if ! influx -username "${INFLUXDB_ADMIN_USERNAME}" -password "${INFLUXDB_ADMIN_PASSWORD}" -execute "show databases";
then
  echo -e "\e[93minitialized.\e[0m"
  influx -execute "CREATE USER \"${INFLUXDB_ADMIN_USERNAME}\" WITH PASSWORD '${INFLUXDB_ADMIN_PASSWORD}' WITH ALL PRIVILEGES"
  export INFLUX_USERNAME=${INFLUXDB_ADMIN_USERNAME}
  export INFLUX_PASSWORD=${INFLUXDB_ADMIN_PASSWORD}
  influx -execute "CREATE DATABASE \"${INFLUXDB_DATABASE}\""
else
      echo -e "\e[93mAlready initialized.\e[0m"
fi
pkill influxd

cd /telegraf-1.15.2/usr/bin/ && ./telegraf &

influxd
