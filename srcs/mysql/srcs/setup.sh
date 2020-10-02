#!/bin/bash

function @eColor() {
  echo -e "\e[91m$1\e[0m"
  eval "${@: 3}"
  echo -e "\e[93m$2\e[0m"
}
# Exit on error
set -e

# Check if mysql is installed
if [ -d "/var/lib/mysql/mysql" ]; then
    echo -e "\e[93mAlready initialized.\e[0m"
    /usr/bin/mysqld --user=root --datadir=/var/lib/mysql
else
    echo -e "\e[36mInitializing..."

    # Setup mysql
    @eColor "Setup..." "Setup Done" mysql_install_db --user=root --datadir=/var/lib/mysql

    # Start mysqld
    @eColor "Starting..." "Starting Done" /usr/bin/mysqld --user=root --datadir=/var/lib/mysql & ./loading_database.sh

    @eColor "Install basic..." "Install basic Done" /usr/bin/mysql -u root -proot < mysql_init
    @eColor "Install PhpMyadmin..." "Install PhpMyadmin Done" /usr/bin/mysql -u root -proot < phpmyadmin.sql
    @eColor "Install UserWordpressTable..." "Install UserWordpressTable Done" /usr/bin/mysql -u root -proot < wordpress.sql
    @eColor "Install UserWordpress..." "Install UserWordpress Done" /usr/bin/mysql -u root -proot < my_user.sql
    pkill mysqld
    /usr/bin/mysqld --user=root --datadir=/var/lib/mysql
fi