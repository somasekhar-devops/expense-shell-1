#!/bin/bash

source ./common.sh

check_root

echo "Plese enter mysql DB Password : "
read -s mysql_root_password

dnf module disable nodejs -y &>>$Logfile
# Validate $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$Logfile
# Validate $? "Enabling Nodejs 20 version"

dnf install nodejs -y &>>$Logfile
# Validate $? "Installing node js"

id expense &>>$Logfile
if [ $? -ne 0 ]
then
    useradd expense &>>$Logfile
    # Validate $? "Creating expense user"
else
    echo -e "expense user already created... $Y Skipping $N"
fi

mkdir -p /app &>>$Logfile
# Validate $? "Creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$Logfile
# Validate $? "Downloading backend code"

cd /app &>>$Logfile
# Validate $? "movng to app directory"

rm -rf /app/* &>>$Logfile
Validate $? "Removing exist files in app directory"

unzip /tmp/backend.zip &>>$Logfile
# Validate $? "Unzipping the backend code"

npm install &>>$Logfile
#Validate $? "Installing nodejs dependencies"

cp /home/ec2-user/expenses-shell/backend.service /etc/systemd/system/backend.service &>>$Logfile
#Validate $? "Copying backend service"

systemctl daemon-reload &>>$Logfile
#Validate $? "Daemon reload"

systemctl start backend &>>$Logfile
#Validate $? "Starting Backend"

systemctl enable backend &>>$Logfile
#Validate $? "Enabling Backend"

dnf install mysql -y &>>$Logfile
#Validate $? "Installing mysql client"

mysql -h db.sekhardevops.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$Logfile
#Validate $? "Setting up mysql client root password"

systemctl restart backend &>>$Logfile
#Validate $? "Restarting the backend"



