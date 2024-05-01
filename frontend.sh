#!/bin/bash

source ./common.sh

check_root

dnf install nginx -y &>>$Logfile
#Validate $? "Installing nginx"

systemctl enable nginx &>>$Logfile
#Validate $? "Enabling nginx"

systemctl start nginx &>>$Logfile
#Validate $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$Logfile
#Validate $? "Removing existing files from the directory"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$Logfile
#Validate $? "Downloading the fronend application"

cd /usr/share/nginx/html &>>$Logfile
#Validate $? "Moving to nginx directory"

unzip /tmp/frontend.zip &>>$Logfile
#Validate $? "Extracting the frontend code"

cp /home/ec2-user/expenses-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$Logfile
#Validate $? "Copying frontend config file"

systemctl restart nginx &>>$Logfile
#Validate $? "Restarting nginx"
