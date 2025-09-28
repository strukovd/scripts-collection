#!/bin/bash

source ./.env

docker run --restart=always \
	--name $CONTAINER_NAME \
	-e TZ=Asia/Bishkek \
	--network=host \
	-v $PATH_TO_DATA:/var/atlassian/application-data/jira \
	-v /etc/localtime:/etc/localtime \
	-d $IMAGE_NAME:$IMAGE_VERSION
