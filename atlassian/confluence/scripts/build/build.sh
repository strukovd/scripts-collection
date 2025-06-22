#!/bin/bash

PATCHER=$(ls -l | awk '/.*patcher.*jar/ {print $NF}')

docker build \
	--build-arg PATCHER=$PATCHER \
	-t patched/confluence:latest ./
