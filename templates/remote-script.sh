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

#docker pull raygoodluck/wireguard
wg_server_public_ip=$1
docker run -d \
  --name=wg-easy \
  -e WG_HOST=$wg_server_public_ip \
  -e PASSWORD=ray_wireguard_admin \
  -v ~/.wg-easy:/etc/wireguard \
  -p 51820:51820/udp \
  -p 51821:51821/tcp \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --restart unless-stopped \
  raygoodluck/wg-web:latest



id
pwd
hostname -I
ifconfig