#!/bin/bash

docker run --restart=always \
--link crowd:crowd --link bitbucket:bitbucket --link jira-software:jira-software --link jira-sd:jira-sd --link confluence:confluence \
--name nginx -p 443:443 -p 80:80 \
-v /msdata/nginx/data/conf:/etc/nginx \
-v /msdata/nginx/data/cache:/var/cache/nginx \
-v /msdata/nginx/data/logs:/var/log/nginx \
-v /etc/localtime:/etc/localtime -d nginx
