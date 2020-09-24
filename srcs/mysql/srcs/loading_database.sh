mysqladmin -u root -proot status
while [ $? != 0 ]
do
    sleep 5
    mysqladmin -u root -proot status
done
/usr/bin/mysql -u root -proot < mysql_init
/usr/bin/mysql -u root -proot < phpmyadmin.sql
