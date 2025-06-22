#!/bin/bash
PG_USERNAME=postgres
PG_CONTAINER_NAME=postgres
TABLES="api__*"
OUTPUT_FILE_NAME=api-tables

docker exec ${PG_CONTAINER_NAME} pg_dump -U ${PG_USERNAME} -d postgres -t ${TABLES} > $OUTPUT_FILE_NAME-dump-$(date +"%d.%m.%Y-%H:%M:%S").sql
