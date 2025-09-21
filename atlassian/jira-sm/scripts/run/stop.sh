#!/bin/bash

source .env

docker stop $CONTAINER_NAME
docker rm -f $CONTAINER_NAME
