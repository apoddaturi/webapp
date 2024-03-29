#!/bin/bash

# to know what updates we have
sudo yum update -y

# to upgrade the packages
sudo yum upgrade -y

# Install Node.js
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install nodejs -y


# sudo tee /etc/yum.repos.d/pgdg.repo<<EOF
# [pgdg13]
# name=PostgreSQL 13 for RHEL/CentOS 7 - x86_64
# baseurl=https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-7-x86_64
# enabled=1
# gpgcheck=0
# EOF

# sudo yum install postgresql13 postgresql13-server -y
# sudo /usr/pgsql-13/bin/postgresql-13-setup initdb

# sudo systemctl start postgresql-13
# sudo systemctl enable postgresql-13
# sudo systemctl status postgresql-13
# Create a new database named "webapp"
#sudo -u postgres createdb webapp

# # Create a new user with the username "webapp" and password "postgres"
# sudo -u postgres psql -c "CREATE USER webapp WITH PASSWORD 'postgres';"

# # Grant all privileges to the "webapp" user on the "webapp" database
# sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE webapp TO webapp;"

# # Restart PostgreSQL service
# sudo systemctl restart postgresql-13

echo "Installing Cloudwatch Agent"

#download cloudwatch agent rpm
sudo wget https://s3.us-east-1.amazonaws.com/amazoncloudwatch-agent-us-east-1/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm

#install cloudwatch agent
sudo rpm -U ./amazon-cloudwatch-agent.rpm

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/home/ec2-user/agentConfig.json -s

#check if cloudwatch agent is running
sudo systemctl status amazon-cloudwatch-agent.service

# Moving to home directory and creating webapp to unzip and run npm i and start

sudo cd ~/

sudo mkdir webapp
sudo unzip webapp.zip -d webapp
sudo chmod 777 webapp

pwd

cd ~/webapp && npm install 

pwd
# Systemd to run node application
sudo mv /home/ec2-user/webapp.service /etc/systemd/system/webapp.service
sudo systemctl enable webapp.service
sudo systemctl start webapp.service
