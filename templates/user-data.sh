#!/bin/bash
#echo 'ClientAliveInterval 60' | tee --append /etc/ssh/sshd_config
cat >> /etc/ssh/sshd_config <<EOF
ClientAliveInterval 60
ClientAliveCountMax 86400
EOF

systemctl restart sshd

echo "start install nginx"
# install nginx
# yum update
# yum -y install nginx
amazon-linux-extras install -y nginx1
amazon-linux-extras install -y epel
yum install -y kmod-wireguard wireguard-tools

# make sure nginx is started
# service nginx start
systemctl start nginx
echo "end start nginx"

cat > /etc/wireguard/wg0.conf << EOF
[Interface]
Address = ${wg_server_net}
PrivateKey = ${wg_server_private_key}
ListenPort = ${wg_server_port}
PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ${wg_server_interface} -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ${wg_server_interface} -j MASQUERADE

# PostUp = iptables -I FORWARD -s ${wg_server_net} -i wg0 -d ${wg_server_net} -j ACCEPT
# PostUp = iptables -I FORWARD -s ${wg_server_net} -i wg0 -d ${lan_net} -j ACCEPT
# PostUp = iptables -I FORWARD -s ${lan_net} -i wg0 -d ${wg_server_net} -j ACCEPT
 
 
# PostDown = iptables -D FORWARD -s ${wg_server_net} -i wg0 -d ${wg_server_net} -j ACCEPT
# PostDown = iptables -D FORWARD -s ${wg_server_net} -i wg0 -d ${lan_net} -j ACCEPT
# PostDown = iptables -D FORWARD -s ${lan_net} -i wg0 -d ${wg_server_net} -j ACCEPT
 

${peers}
EOF

chown -R root:root /etc/wireguard/
chmod -R og-rwx /etc/wireguard/*
# sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
# sed -i '$anet.ipv4.ip_forward=1' /etc/sysctl.conf
cat >> /etc/sysctl.conf << EOF
net.ipv4.ip_forward=1
net.ipv6.conf.default.forward=1
net.ipv6.conf.all.forward=1
EOF
sysctl -p
# ufw allow ssh
# ufw allow ${wg_server_port}/udp
# ufw --force enable
systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service

# install docker for running http proxy squid
yum install -y docker
systemctl enable docker
systemctl start docker
docker pull ubuntu/squid
docker run -d --name squid-container -e TZ=UTC -p 3128:3128 ubuntu/squid

hostname -I
ifconfig
