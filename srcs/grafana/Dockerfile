FROM alpine:latest

EXPOSE 3000

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

RUN apk add libc6-compat gcompat
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz
RUN tar xf telegraf-1.15.2_linux_amd64.tar.gz -C /
RUN rm telegraf-1.15.2_linux_amd64.tar.gz

COPY srcs/telegraf.conf /etc/telegraf/

COPY ./srcs/grafana.ini /etc/.
COPY ./srcs/setup.sh /.
COPY ./srcs/influxdb.yaml /usr/share/grafana/conf/provisioning/datasources
RUN chmod +x /setup.sh

ENTRYPOINT ["/bin/sh", "/setup.sh"]