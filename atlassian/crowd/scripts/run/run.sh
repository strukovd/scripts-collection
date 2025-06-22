#!/bin/bash

VOLUME_PATH=/opt/volume
docker run -d \
	--restart=always \
	--name crowd \
	--network=atlassian_network \
	-e TZ=Asia/Bishkek \
	-p 8095:8095 \
	-v $VOLUME_PATH/atlassian/crowd/data:/var/atlassian/application-data/crowd \
	-v /etc/localtime:/etc/localtime \
	atlassian/crowd
