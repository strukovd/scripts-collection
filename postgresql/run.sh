#!/bin/bash

VERSION='latest'
CONTAINER_NAME=pg
IMAGE_NAME=postgres
FOLDER_WITH_DATA=data
PATH_TO_DATA="$(pwd)/$CONTAINER_NAME-$FOLDER_WITH_DATA"

docker run -d \
	--name $CONTAINER_NAME \
	--network=host \
	-e POSTGRES_USER=postgres \
	-e POSTGRES_PASSWORD=postgres \
	-e POSTGRES_DB=postgres \
	-e TZ=Asia/Bishkek \
	-v /etc/localtime:/etc/localtime \
	-v $PATH_TO_DATA:/var/lib/postgresql/data \
	$IMAGE_NAME:$VERSION
