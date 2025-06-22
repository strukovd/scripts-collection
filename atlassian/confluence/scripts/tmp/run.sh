#!/bin/bash

docker run -d --name=confluence \
           --link=postgres \
           --link=jira \
           --ip=172.17.0.16 \
           --restart=always \
           -v /etc/localtime:/etc/localtime \
           -v /home/ask/msdata/confluence/data/confluence_data:/var/atlassian/application-data/confluence \
           -p 8090:8090 -p 8091:8091 \
	   -e ATL_TOMCAT_SECURE=true \
	   -e ATL_TOMCAT_SCHEME=https \
	   -e ATL_PROXY_NAME=ib.askartec.com \
	   -e ATL_PROXY_PORT=1443 \
	   -e ATL_TOMCAT_CONTEXTPATH=/confluence \
           -e ATL_JDBC_URL=jdbc:postgresql://postgres:5432/confluencedb \
           -e ATL_JDBC_USER=confluence_user \
           -e ATL_JDBC_PASSWORD=confluence_pwd \
           -e ATL_DB_TYPE=postgresql \
           opt/confluence
