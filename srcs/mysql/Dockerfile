FROM alpine:latest

EXPOSE 3306

RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add mysql --no-cache
RUN apk add mysql-client --no-cache
RUN apk add bash --no-cache

RUN mkdir -p /run/mysqld

COPY ./srcs/mariadb-server.cnf ./etc/my.cnf.d/
COPY ./srcs/ /

RUN chmod +x /setup.sh
RUN chmod 0444 /etc/my.cnf.d/mariadb-server.cnf

ENTRYPOINT ["/bin/bash", "/setup.sh"]