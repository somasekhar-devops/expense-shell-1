#!/bin/bash

source ./common.sh

echo "Plese enter mysql DB Password : "
read mysql_root_password

check_root

dnf install mysql-server -y &>>$Logfile
# Validate $? "Installing mysql server"

systemctl enable mysqld &>>$Logfile
# Validate $? "Enabling mysql server"

systemctl start mysqld &>>$Logfile
# Validate $? "Starting mysql server"

mysql -h db.sekhardevops.online -uroot -pExpenseApp@1 -e 'SHOW DATABASES;' &>>$Logfile
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$Logfile
    # Validate $? "Setting up the root password for mysql server"
else
    echo -e "Mysql passowrd setup already done ...$Y Skipping..$N"
fi