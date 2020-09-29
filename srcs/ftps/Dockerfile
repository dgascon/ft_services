FROM alpine:latest

EXPOSE 21 40000-40010

RUN apk update --no-cache
RUN apk upgrade --no-cache

RUN apk add vsftpd --no-cache
RUN apk add openssl --no-cache

RUN apk add openrc --no-cache

RUN openrc boot

RUN adduser -D -g 'admin' admin
RUN echo "admin:admin" | chpasswd

RUN mkdir -p /etc/vsftpd/ssl

COPY ./srcs/vsftpd.conf /etc/vsftpd/vsftpd.conf

RUN openssl req -new -x509 -days 365 -nodes -out /etc/ssl/private/vsftpd.cert.pem -keyout /etc/ssl/private/vsftpd.key.pem -subj "/C=FR/ST=France/L=Lyon/O=42Lyon/OU=42Network/CN=localhost/emailAddress=dgascon@student.42lyon.fr"

RUN chown root:root /etc/ssl/private/vsftpd.cert.*
RUN chmod 600 /etc/ssl/private/vsftpd.cert.*

RUN rc-service vsftpd restart