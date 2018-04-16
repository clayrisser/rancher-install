#!/bin/sh

read -p "Email: " EMAIL
read -p "Rancher hostname: " RANCHER_HOSTNAME
read -p "Mysql hostname: " MYSQL_HOSTNAME
read -p "Mysql user: " MYSQL_USER
read -p "Mysql password: " MYSQL_PASSWORD
read -p "Mysql database: " MYSQL_DATABASE

curl -L https://raw.githubusercontent.com/codejamninja/dsrp/master/dsrp.sh | sudo bash 2>/dev/null

sudo docker run --name rancher \
    -d --restart=unless-stopped \
    -e CATTLE_PROMETHEUS_EXPORTER=true \
    -e VIRTUAL_HOST=$RANCHER_HOSTNAME \
    -e VIRTUAL_PORT=8080 \
    -e LETSENCRYPT_HOST=$RANCHER_HOSTNAME \
    -e LETSENCRYPT_EMAIL=$EMAIL \
    -p 9108:9108 \
    rancher/server:latest \
        --db-host $MYSQL_HOSTNAME \
        --db-port 3306 \
        --db-user $MYSQL_USER \
        --db-pass $MYSQL_PASSWORD \
        --db-name $MYSQL_DATABASE
