#!/bin/bash

# Значения по умолчанию
DB_NAME=""
PG_USER="postgres"
CONTAINER=""

# Обработка флагов: n (name), u (user), c (container)
while getopts "n:u:c:" opt; do
  case $opt in
    n) DB_NAME="$OPTARG" ;;
    u) PG_USER="$OPTARG" ;;
    c) CONTAINER="$OPTARG" ;;
    *) echo "Usage: $0 -n <db_name> [-u <user>] [-c <container_name>]"; exit 1 ;;
  esac
done

if [ -z "$DB_NAME" ]; then
  echo "Ошибка: Укажите имя базы через -n"
  exit 1
fi

DATE_STR=$(date +%d-%m-%Y_%H_%M_%S)
FILE_NAME="dump_${DB_NAME}_${DATE_STR}.backup"

echo "--- Backup started: $(date +'%H:%M:%S') ---"

if [ -n "$CONTAINER" ]; then
  echo "Mode: DOCKER ($CONTAINER)"
  docker exec "$CONTAINER" pg_dump -U "$PG_USER" -d "$DB_NAME" -Fc > "$FILE_NAME"
else
  echo "Mode: LOCAL"
  pg_dump -U "$PG_USER" -d "$DB_NAME" -Fc -f "$FILE_NAME"
fi

if [ $? -eq 0 ]; then
  echo "Success: $FILE_NAME"
  ls -lh "$FILE_NAME"
else
  echo "--- Backup FAILED ---"
  exit 1
fi
