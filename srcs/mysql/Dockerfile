FROM alpine:latest

RUN apk -U upgrade

RUN apk add mysql

RUN apk add mysql-client

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

RUN apk add openrc

RUN openrc reboot

COPY ./setup.sh .

RUN chmod +x ./setup.sh

CMD sh setup.sh

