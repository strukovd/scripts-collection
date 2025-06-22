#!/bin/bash

#TODO добавить volume к пути /opt/atlassian/jira/atlassian-jira там где images, и поделить это в папке data (home и build понять где что)
PORT=80
CONTAINER_NAME=jira-gp
IMAGE_NAME=patched/jira-software:8.1
FOLDER_WITH_DATA=data/home
FOLDER_BUILD=data/build
PATH_TO_DATA=$(pwd | sed 's:script.*::')$FOLDER_WITH_DATA
PATH_TO_BUILD=$(pwd | sed 's:script.*::')$FOLDER_BUILD

docker run --restart=always \
	--name $CONTAINER_NAME \
	--network=atlassian_network \
	-e TZ=Asia/Bishkek \
	-p $PORT:8080 \
	-v $PATH_TO_DATA:/var/atlassian/application-data/jira \
	-v /etc/localtime:/etc/localtime \
	-d $IMAGE_NAME

