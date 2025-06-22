#!/bin/bash

docker run --restart=always --name jira-sd --link=postgres:postgres --link=crowd:crowd -e TZ=Asia/Bishkek \
-e CATALINA_CONNECTOR_PROXYNAME=sd.bank.local -e CATALINA_CONNECTOR_PROXYPORT=443 -e CATALINA_CONNECTOR_SCHEME=https -e CATALINA_CONNECTOR_SECURE=true \
-p 8081:8080 -v /msdata/jira-sd/data:/var/atlassian/application-data/jira \
-v /etc/localtime:/etc/localtime -d opt/jira-sd


#docker run --net=host --restart=always --name postgres -e TZ=Europe/Moscow -e PGTZ=Europe/Moscow -e POSTGRES_PASSWORD=Postgres@@Rysgal -v /home/rysgalpay/msdata/postgres/data:/var/lib/postgresql/data -v /etc/localtime:/etc/localtime -d postgres
