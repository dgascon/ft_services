FROM alpine:latest

EXPOSE 8086

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add influxdb --no-cache

RUN apk add libc6-compat gcompat
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz
RUN tar xf telegraf-1.15.2_linux_amd64.tar.gz -C /
RUN rm telegraf-1.15.2_linux_amd64.tar.gz

COPY srcs/telegraf.conf /etc/telegraf/

COPY ./srcs/setup.sh /setup.sh
COPY ./srcs/influxdb.conf /etc/.
RUN chmod +x /setup.sh

ENTRYPOINT ["/bin/sh", "/setup.sh"]
