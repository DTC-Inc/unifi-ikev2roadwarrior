#!/bin/bash

echo "What is the publicly accessbile FQDN?"
read leftid
echo "What is the local reachable subnets? 0.0.0.0/0 for redirect gateway."
read leftsubnet
echo "What is the virtual network subnet?"
read rightsourceip
echo "What are the domain controllers/dns servers? Comma seperated please"
read rightdns
echo "What is the radius server IP?"
read radiusserver

mkdir /config/ipsec
curl -o /config/ipsec/ipsec.conf https://github.com/dtc/ubnt/ipsec.conf
curl -o /config/scripts/install.acme.sh https://github.com/dtc/install.acme.sh
curl -o /config/scripts/post-config.d/ipsec-commit.sh https://github.com/dtc/ipsec-commit.sh

bash /config/scripts/install.acme.sh

bash /config/scripts/renew.acme.sh -d $leftid

echo "$leftid : RSA /config/.acme.sh/$leftid/$leftid.key" > /config/ipsec/ipsec.secrets
echo "leftid=$leftid" >> /config/ipsec/ipsec.conf
echo "leftcert=/config/.acme.sh/$leftid/fullchain.cer" >> /config/ipsec/ipsec.conf
echo "leftsubnet=$leftsubnet" >> /config/ipsec/ipsec.conf
echo "rightdns=$rightdns" >> /config/ipsec/ipsec.conf
echo "rightsourceip=$rightsourceip" >> /config/ipsec/ipsec.conf

