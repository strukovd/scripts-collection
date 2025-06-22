#!/bin/bash


docker run -d  --link postgres  --link jira \
    --name=bitbucket \
    --restart=always \
    --ip=172.17.0.15 \
    -v /etc/localtime:/etc/localtime \
    -e JDBC_DRIVER=org.postgresql.Driver \
    -e SERVER_PROXY_PORT=1443 \
    -e SERVER_PROXY_NAME=ib.askartec.com \
    -e SERVER_SCHEME=https \
    -e SERVER_SECURE=true \
    -e SERVER_CONTEXT_PATH=/bitbucket \
    -e JDBC_USER=bitbuck_user \
    -e JDBC_PASSWORD=bitbuck_pwd \
    -e JDBC_URL=jdbc:postgresql://postgres:5432/bitbucketdb \
    -v /home/ask/msdata/bitbucket/data/bitbucket:/var/atlassian/application-data/bitbucket \
    -p 7990:7990 -p 7999:7999 -p 1450:1450 \
     opt/bitbucket

  #-v /home/ask/msdata/bitbucket/data/bitbucket:/var/atlassian/application-data/bitbucket/shared \
