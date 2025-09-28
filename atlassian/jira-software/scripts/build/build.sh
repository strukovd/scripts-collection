#!/bin/bash

PATCHER=$(ls -l | awk '/.*patcher.*jar/ {print $NF}')

docker build \
	--build-arg PATCHER=$PATCHER \
	-t atlassian/jira-software:9.12.6-p ./

