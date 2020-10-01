FROM alpine:latest

EXPOSE 8086

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add influxdb --no-cache

ENV INFLUXDB_HTTP_AUTH_ENABLED=true

ENV INFLUXDB_ADMIN_USERNAME=user42influxdb

ENV INFLUXDB_ADMIN_PASSWORD=password42influxdb

ENV TELEGRAF_ADMIN_USERNAME=user42telegraf

ENV TELEGRAF_ADMIN_PASSWORD=password42telegraf

ENV GRAFANA_ADMIN_USERNAME=user42grafana

ENV GRAFANA_ADMIN_PASSWORD=password42grafana

ENV INFLUXDB_DATABASE=database42

ENV INFLUXDB_META_DIR="/var/lib/influxdb/meta"

ENV INFLUXDB_DATA_DIR="/var/lib/influxdb/data"

ENV INFLUXDB_DATA_WAL_DIR="/var/lib/influxdb/wal"

COPY ./srcs/setup.sh ./setup.sh

RUN chmod +x ./setup.sh

ENTRYPOINT ["/bin/sh", "./setup.sh"]
