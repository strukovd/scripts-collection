#!/bin/bash

VERSION='14'
FOLDER_WITH_DATA=data
CONTAINER_NAME=pg
IMAGE_NAME=postgres
PATH_TO_DATA=$(pwd | sed 's:script.*::')$FOLDER_WITH_DATA

docker run -d \
    --name $CONTAINER_NAME \
    -p 5432:5432 \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=postgres \
    -e TZ=Asia/Bishkek \
    -v /etc/localtime:/etc/localtime \
    -v $PATH_TO_DATA:/var/lib/postgresql/data \
    $IMAGE_NAME:$VERSION
