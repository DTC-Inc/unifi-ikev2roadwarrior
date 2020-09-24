#!/bin/bash

echo "What is the publicly accessbile FQDN?"
read leftId
echo "What is the local reachable subnets? 0.0.0.0/0 for redirect gateway."
read leftSubnet
echo "What is the virtual network subnet?"
read rightSourceIp
echo "What are the domain controllers/dns servers? Comma seperated please"
read rightDns
echo "What is the radius server IP?"
read radiusServer

mkdir /config/ipsec
curl -o /config/ipsec/ipsec.conf https://raw.githubusercontent.com/DTC-Inc/unifi-ikev2roadwarrior/master/conf/ipsec.conf
curl -o /config/scripts/install.sh https://raw.githubusercontent.com/DTC-Inc/unifi-ikev2roadwarrior/mater/dep/install.sh
curl -o /config/scripts/post-config.d/ipsec-commit.sh https://raw.githubusercontent.com/DTC-Inc/unifi-ikev2roadwarrior/master/ipsec-commit.sh

bash /config/scripts/install.sh

bash /config/scripts/renew.acme.sh -d $leftid

echo "$leftid : RSA /config/.acme.sh/$leftid/$leftid.key" > /config/ipsec/ipsec.secrets
echo "leftid=$leftid" >> /config/ipsec/ipsec.conf
echo "leftcert=/config/.acme.sh/$leftid/fullchain.cer" >> /config/ipsec/ipsec.conf
echo "leftsubnet=$leftsubnet" >> /config/ipsec/ipsec.conf
echo "rightdns=$rightdns" >> /config/ipsec/ipsec.conf
echo "rightsourceip=$rightsourceip" >> /config/ipsec/ipsec.conf

