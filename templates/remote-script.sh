#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done
# echo "start install nginx"
# # install nginx
# # yum update
# # yum -y install nginx
# amazon-linux-extras install -y nginx1
# id
# pwd
# # make sure nginx is started
# # service nginx start
# systemctl start nginx
# echo "end start nginx"

id
pwd
hostname -I
ifconfig