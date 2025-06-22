#!/bin/bash

FOLDER_WITH_DATA=data
PATH_TO_DATA=$(pwd | sed 's:script.*::')$FOLDER_WITH_DATA
CONTAINER_NAME=confluence
IMAGE_NAME=patched/confluence:latest

docker run -d --restart=always \
	--name $CONTAINER_NAME \
	--network=atlassian_network \
	-e TZ=Asia/Bishkek \
	-p 8090:8090 \
	-p 8091:8091 \
	-v $PATH_TO_DATA:/var/atlassian/application-data/confluence \
	-v /etc/localtime:/etc/localtime \
	$IMAGE_NAME
