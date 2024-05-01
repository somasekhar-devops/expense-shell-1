#!/bin/bash

source ./common.sh

check_root

echo "Plese enter mysql DB Password : "
read -s mysql_root_password

dnf install mysql-server -y &>>$Logfile
#Validate $? "Installing mysql server"

systemctl enable mysqld &>>$Logfile
#Validate $? "Enabling mysql server"

systemctl start mysqld &>>$Logfile
#Validate $? "Starting mysql server"

mysql -h db.sekhardevops.online -uroot -p${mysql_root_password} -e 'SHOW DATABASES;' &>>$Logfile
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$Logfile
    #Validate $? "Setting up the root password for mysql server"
else
    echo -e "Mysql passowrd setup already done ...$Y Skipping..$N"
fi