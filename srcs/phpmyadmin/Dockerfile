FROM alpine:latest

EXPOSE 5000

RUN apk update --no-cache
RUN apk upgrade --no-cache

RUN apk add --no-cache php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN apk add libc6-compat gcompat
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz
RUN tar xf telegraf-1.15.2_linux_amd64.tar.gz -C /
RUN rm telegraf-1.15.2_linux_amd64.tar.gz

COPY srcs/telegraf.conf /etc/telegraf/

RUN mkdir -p /www
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
RUN tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
RUN mv phpMyAdmin-5.0.2-all-languages/* /www/.
RUN rm -rf phpMyAdmin-5.0.2-all-languages.tar.gz phpMyAdmin-5.0.2-all-languages

COPY ./srcs/setup.sh .
COPY ./srcs/config.inc.php /www/.

RUN chmod +x /setup.sh
RUN chmod a-w /www/config.inc.php

ENTRYPOINT ["/bin/sh", "/setup.sh"]