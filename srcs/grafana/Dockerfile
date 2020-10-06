FROM alpine:latest

EXPOSE 3000

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

COPY ./srcs/grafana.ini /etc/.
COPY ./srcs/setup.sh /.
COPY ./srcs/influxdb.yaml /usr/share/grafana/conf/provisioning/datasources
RUN chmod +x /setup.sh

ENTRYPOINT ["/bin/sh", "/setup.sh"]