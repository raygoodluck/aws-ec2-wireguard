#!/bin/bash -x
echo ${aws_instance_public_ip}
sudo sed -i "s/Endpoint.*/Endpoint = ${aws_instance_public_ip}:51820/"  /etc/wireguard/wg0.conf
sudo cat /etc/wireguard/wg0.conf
sudo systemctl start wg-quick@wg0
# sudo systemctl restart wg-quick@wg0
# sudo systemctl status wg-quick@wg0
# The strip command is useful for reloading configuration files without disrupting active sessions
sudo wg syncconf wg0 <(wg-quick strip wg0)
sudo wg
