/etc/init.d/mariadb start

echo "CREATE DATABASE wpdb;" | mysql
echo "CREATE USER 'user42'@'localhost' identified by 'user42';" | mysql
echo "GRANT ALL PRIVILEGES ON *.* TO 'user42'@'localhost';" | mysql
echo "FLUSH PRIVILEGES;" | mysql

/usr/bin/mysqld_safe --datadir='/var/lib/mysql'