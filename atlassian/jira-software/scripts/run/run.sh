#!/bin/bash

FOLDER_WITH_DATA=data
PATH_TO_DATA=$(pwd | sed 's:script.*::')$FOLDER_WITH_DATA
PORT=8080
CONTAINER_NAME=jira-dev
IMAGE_NAME=atlassian/jira-software:8.22


docker run --restart=always \
	--name $CONTAINER_NAME \
	--network=atlassian_network \
	-e TZ=Asia/Bishkek \
	-p $PORT:8080 \
	-v $PATH_TO_DATA:/var/atlassian/application-data/jira \
	-v /etc/localtime:/etc/localtime \
	-d $IMAGE_NAME
