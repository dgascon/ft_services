FROM alpine:latest

RUN apk -U upgrade

RUN apk add mysql

RUN apk add mysql-client
RUN mkdir -p /run/mysqld
RUN mysql_install_db --user=root --datadir=/var/lib/mysql

COPY ./setup.sh .
RUN chmod +x ./setup.sh
RUN sed -i -e "/skip-networking/d" /etc/my.cnf.d/mariadb-server.cnf
EXPOSE 3306
CMD ./setup.sh

