#!/bin/bash

# Проверяем, передан ли аргумент (имя базы)
if [ -z "$1" ]; then
  echo "Ошибка: укажите имя базы данных."
  echo "Использование: $0 <имя_бд>"
  exit 1
fi

PG_USERNAME=postgres
PG_CONTAINER_NAME=postgres
DB_NAME=$1
DATE_STR=$(date +%d-%m-%Y_%H_%M_%S)
FILE_NAME="dump_${DB_NAME}_${DATE_STR}.backup"

echo "--- Backup started at: $(date +'%H:%M:%S') ---"

docker exec ${PG_CONTAINER_NAME} pg_dump -U ${PG_USERNAME} -d ${DB_NAME} -Fc > "${FILE_NAME}"

if [ $? -eq 0 ]; then
  echo "--- Backup finished at: $(date +'%H:%M:%S') ---"
  echo "Success: dump_${DATE_STR}.dump"
  ls -lh "${FILE_NAME}"
else
  echo "--- Backup FAILED at: $(date +'%H:%M:%S') ---"
  exit 1
fi
