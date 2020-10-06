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
  influx -execute "CREATE USER \"${TELEGRAF_ADMIN_USERNAME}\" WITH PASSWORD '${TELEGRAF_ADMIN_PASSWORD}'"
  influx -execute "GRANT WRITE ON \"${INFLUXD_DATABBASE}\" TO \"${TELEGRAF_ADMIN_USERNAME}\""
  influx -execute "CREATE USER \"${GRAFANA_ADMIN_USERNAME}\" WITH PASSWORD '${GRAFANA_ADMIN_PASSWORD}'"
  influx -execute "GRANT READ ON \"${INFLUXDB_DATABASE}\" TO \"${GRAFANA_ADMIN_USERNAME}\""
else
      echo -e "\e[93mAlready initialized.\e[0m"
fi
pkill influxd
influxd
