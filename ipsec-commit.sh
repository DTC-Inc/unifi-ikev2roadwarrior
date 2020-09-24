#!/bin/bash
curl -o /config/ipsec/letsencrypt.ca.cer https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt
ln -s /config/ipsec/letsencrypt.ca.cer /etc/ipsec.d/cacerts/letsencrypt.ca.cer
echo 'include /config/ipsec/charon-cust*.conf' >> /etc/strongswan.conf
ipsec restart