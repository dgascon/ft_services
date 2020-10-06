FROM alpine:latest

EXPOSE 3000

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add grafana --repository http://dl-3.alpinelinux.org/alpine/edge/testing/

COPY ./srcs/grafana.ini /etc/.
COPY ./srcs/setup.sh /.
COPY ./srcs/influxdb.yaml /usr/share/grafana/conf/provisioning/datasources
COPY ./srcs/dashboards/. /var/lib/grafana/dashboards/.
COPY ./srcs/dashboard_conf.yaml /usr/share/grafana/conf/provisioning/dashboards/.
RUN chmod +x /setup.sh

ENTRYPOINT ["/bin/sh", "/setup.sh"]