#!/bin/bash

FILE=""
DB_NAME=""
PG_USER="postgres"
CONTAINER=""
TABLES_INPUT=""

# Добавили опцию -t для выборочного восстановления
while getopts "f:n:u:c:t:" opt; do
  case $opt in
    f) FILE="$OPTARG" ;;
    n) DB_NAME="$OPTARG" ;;
    u) PG_USER="$OPTARG" ;;
    c) CONTAINER="$OPTARG" ;;
    t) TABLES_INPUT="$OPTARG" ;; # Список таблиц для восстановления
    *) echo "Usage: $0 -f <file> -n <db> [-u <user>] [-c <container>] [-t <tables>]"; exit 1 ;;
  esac
done

if [ -z "$FILE" ] || [ -z "$DB_NAME" ]; then
  echo "Ошибка: Укажите файл (-f) и целевую базу (-n)"
  exit 1
fi

# Формируем флаги таблиц, если они переданы
TABLE_FLAGS=""
for t in $TABLES_INPUT; do
  TABLE_FLAGS="$TABLE_FLAGS -t $t"
done

echo "--- Restore started at: $(date +'%H:%M:%S') ---"

if [ -n "$CONTAINER" ]; then
  echo "Mode: DOCKER ($CONTAINER)"
  # Используем -i для передачи файла в поток контейнера
  docker exec -i "$CONTAINER" pg_restore -U "$PG_USER" -d "$DB_NAME" $TABLE_FLAGS --no-owner -v < "$FILE"
else
  echo "Mode: LOCAL"
  pg_restore -U "$PG_USER" -d "$DB_NAME" $TABLE_FLAGS --no-owner -v "$FILE"
fi

if [ $? -eq 0 ]; then
  echo "--- Restore SUCCESS ---"
else
  echo "--- Restore FAILED ---"
  exit 1
fi
