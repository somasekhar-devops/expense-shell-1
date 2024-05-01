#!/bin/bash

source ./common.sh

check_root

echo "Plese enter mysql DB Password : "
read -s mysql_root_password

dnf module disable nodejs -y &>>$Logfile

dnf module enable nodejs:20 -y &>>$Logfile

dnf install nodejs -y &>>$Logfile

id expense &>>$Logfile
if [ $? -ne 0 ]
then
    useradd expense &>>$Logfile
    
else
    echo -e "expense user already created... $Y Skipping $N"
fi

mkdir -p /app &>>$Logfile

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$Logfile

cd /app &>>$Logfile

rm -rf /app/* &>>$Logfile

unzip /tmp/backend.zip &>>$Logfile

npm install &>>$Logfile

cp /home/ec2-user/expense-shell-1/backend.service /etc/systemd/system/backend.service &>>$Logfile

systemctl daemon-reload &>>$Logfile

systemctl start backend &>>$Logfile

systemctl enable backend &>>$Logfile

dnf install mysql -y &>>$Logfile

mysql -h db.sekhardevops.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$Logfile

systemctl restart backend &>>$Logfile
