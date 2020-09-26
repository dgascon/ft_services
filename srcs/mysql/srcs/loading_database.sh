mysqladmin -u root -proot status
while [ $? != 0 ]
do
    sleep 5
    mysqladmin -u root -proot status
done
