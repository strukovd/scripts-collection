#!/bin/bash

VERSION='14-3.4'
FOLDER_WITH_DATA=data
CONTAINER_NAME=osm-pg
IMAGE_NAME=postgis/postgis
PATH_TO_DATA=$(pwd)/$FOLDER_WITH_DATA

docker run -d \
    --name $CONTAINER_NAME \
	--network=host \
    -e POSTGRES_USER=osm \
    -e POSTGRES_PASSWORD=osm123 \
    -e POSTGRES_DB=osm \
    -e TZ=Asia/Bishkek \
    -v /etc/localtime:/etc/localtime \
    -v $PATH_TO_DATA:/var/lib/postgresql/data \
    $IMAGE_NAME:$VERSION
