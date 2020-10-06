FROM alpine:latest

EXPOSE 8086

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add influxdb --no-cache

ENV INFLUXDB_HTTP_AUTH_ENABLED=true

ENV INFLUXDB_ADMIN_USERNAME=admin

ENV INFLUXDB_ADMIN_PASSWORD=admin

ENV INFLUXDB_DATABASE=database42

ENV INFLUXDB_META_DIR=/var/lib/influxdb/meta

ENV INFLUXDB_DATA_DIR=/var/lib/influxdb/data

ENV INFLUXDB_DATA_WAL_DIR=/var/lib/influxdb/wal

RUN apk add libc6-compat gcompat
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz
RUN tar xf telegraf-1.15.2_linux_amd64.tar.gz -C /
RUN rm telegraf-1.15.2_linux_amd64.tar.gz

COPY srcs/telegraf.conf /etc/telegraf/

# RUN mkdir -p /var/lib/influxd/data/database42

COPY ./srcs/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["/bin/sh", "/setup.sh"]
