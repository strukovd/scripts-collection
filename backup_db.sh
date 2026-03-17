#!/bin/bash

if [ -z "$1" ]; then
  echo "Использование: $0 <имя_бд>"
  exit 1
fi

DB_NAME=$1
PG_USERNAME="postgres"
DATE_STR=$(date +%d-%m-%Y_%H_%M_%S)
FILE_NAME="dump_${DB_NAME}_${DATE_STR}.backup"

# Если нужен пароль, раскомментируй строку ниже:
# export PGPASSWORD='ваш_пароль'

echo "--- Backup started at: $(date +'%H:%M:%S') ---"

# Выполняем команду напрямую в системе
pg_dump -U ${PG_USERNAME} -d ${DB_NAME} -Fc -f "${FILE_NAME}"

if [ $? -eq 0 ]; then
  echo "--- Backup finished at: $(date +'%H:%M:%S') ---"
  echo "Success: ${FILE_NAME}"
  ls -lh "${FILE_NAME}"
else
  echo "--- Backup FAILED at: $(date +'%H:%M:%S') ---"
  exit 1
fi
