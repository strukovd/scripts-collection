#!/bin/bash

FILE=""
DB_NAME=""
PG_USER="postgres"
CONTAINER=""

while getopts "f:n:u:c:" opt; do
  case $opt in
    f) FILE="$OPTARG" ;;
    n) DB_NAME="$OPTARG" ;;
    u) PG_USER="$OPTARG" ;;
    c) CONTAINER="$OPTARG" ;;
    *) echo "Usage: $0 -f <file> -n <db_name> [-u <user>] [-c <container_name>]"; exit 1 ;;
  esac
done

if [ -z "$FILE" ] || [ -z "$DB_NAME" ]; then
  echo "Ошибка: Укажите файл (-f) и имя базы (-n)"
  exit 1
fi

echo "--- Restore started: $(date +'%H:%M:%S') ---"

if [ -n "$CONTAINER" ]; then
  echo "Mode: DOCKER ($CONTAINER)"
  docker exec -i "$CONTAINER" pg_restore -U "$PG_USER" -d "$DB_NAME" --no-owner -v < "$FILE"
else
  echo "Mode: LOCAL"
  pg_restore -U "$PG_USER" -d "$DB_NAME" --no-owner -v "$FILE"
fi

if [ $? -eq 0 ]; then
  echo "--- Restore SUCCESS ---"
else
  echo "--- Restore FAILED ---"
  exit 1
fi
