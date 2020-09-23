#/etc/init.d/mariadb start
#rc-update add mariadb default
#/usr/bin/mysqladmin -u root password 'password'
mkdir -p /usr/share/webapps/
cd /usr/share/webapps
apk add wget
wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz
tar zxvf phpMyAdmin-5.0.2-all-languages.tar.gz
rm phpMyAdmin-5.0.2-all-languages.tar.gz
chown -R lighttpd /usr/share/webapps/
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
ln -s /usr/share/webapps/phpmyadmin/ /var/www/localhost/htdocs/phpmyadmin
rc-service lighttpd restart
/usr/bin/mysqld_safe --datadir='/var/lib/mysql'