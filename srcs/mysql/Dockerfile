FROM alpine:latest

EXPOSE 3306

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add mysql --no-cache
RUN apk add mysql-client --no-cache
RUN mkdir -p /run/mysqld

#Setup mysql
RUN mysql_install_db --user=root --datadir=./data

COPY ./srcs/mariadb-server.cnf ./etc/my.cnf.d/
COPY ./srcs/ /

ENTRYPOINT ["/bin/sh", "/setup.sh"]