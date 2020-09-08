FROM alpine:latest

RUN apk -U upgrade && apk add nginx && apk add openssl

RUN adduser -D -g 'www' www

RUN mkdir -p /run/nginx /www /etc/nginx/ssl

RUN chown -R www:www /var/lib/nginx && chown -R www:www /www

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/default.key -out /etc/nginx/ssl/default.crt \
    -subj "/C=FR/ST=France/L=Lyon/O=42Lyon/OU=42Network/CN=localhost/emailAddress=dgascon@student.42lyon.fr"

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./index.html /www/index.html

RUN nginx

EXPOSE 80 443

CMD nginx -g 'daemon off;'