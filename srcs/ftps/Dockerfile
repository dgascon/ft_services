FROM alpine:latest

EXPOSE 21 40000-40010

RUN apk update --no-cache
RUN apk upgrade --no-cache

RUN apk add vsftpd --no-cache
RUN apk add openssl --no-cache

RUN apk add openrc --no-cache

RUN openrc boot

RUN apk add libc6-compat gcompat
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz
RUN tar xf telegraf-1.15.2_linux_amd64.tar.gz -C /
RUN rm telegraf-1.15.2_linux_amd64.tar.gz

COPY srcs/telegraf.conf /etc/telegraf/

RUN adduser -D -g 'admin' admin
RUN echo "admin:admin" | chpasswd

RUN mkdir -p /etc/vsftpd/ssl

COPY ./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN openssl req -new -x509 -days 365 -nodes -out /etc/ssl/private/vsftpd.cert.pem -keyout /etc/ssl/private/vsftpd.key.pem \
    -subj "/C=FR/ST=France/L=Lyon/O=42Lyon/OU=42Network/CN=localhost/emailAddress=dgascon@student.42lyon.fr"

COPY ./srcs/setup.sh /setup.sh
RUN chmod +x /setup.sh

ENTRYPOINT ["/bin/sh", "/setup.sh"]