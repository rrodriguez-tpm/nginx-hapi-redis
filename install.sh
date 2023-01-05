#!/bin/bash
if [ $# -ne 3 ]; then
   echo 'Error'
   echo 'Requires 3 parameters: $USER domain-name email'
   exit 1
else
# takes three paramters, current user, the domain name and the email to be associated with the certificate
   USER=$1
   DOMAIN=$2
   EMAIL=$3

   echo DOMAIN=${DOMAIN} >> .env
   echo EMAIL=${EMAIL} >> .env

# Phase 1
   docker-compose -f ./docker-compose-initiate.yaml up -d nginx
   docker-compose -f ./docker-compose-initiate.yaml up certbot
   docker-compose -f ./docker-compose-initiate.yaml down

   echo 'Starting some configurations for lets encrypt'
# some configurations for let's encrypt
   curl -L --create-dirs -o etc/letsencrypt/options-ssl-nginx.conf https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf
   openssl dhparam -out etc/letsencrypt/ssl-dhparams.pem 2048

# Phase 2
   crontab -u $USER ./etc/crontab
   docker-compose -f ./docker-compose.yaml up -d
fi
