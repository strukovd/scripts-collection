#!/bin/bash

VOLUME_PATH=/opt/volume
docker run -d \
    --restart=always \
    --name bitbucket \
    --network=atlassian_network \
    -e TZ=Asia/Bishkek \
    -p 7990:7990 \
    -p 7999:7999 \
    -v $VOLUME_PATH/atlassian/bitbucket/data:/var/atlassian/application-data/bitbucket \
    -v /etc/localtime:/etc/localtime \
    patched/bitbucket

