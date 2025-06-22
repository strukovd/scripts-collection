#!/bin/bash

CONTAINER_NAME=cms-pg
USER=postgres
SQL_FILE_NAME=dump-api-tables.sql

cat $SQL_FILE_NAME | docker exec -i $CONTAINER_NAME psql -U $USER
