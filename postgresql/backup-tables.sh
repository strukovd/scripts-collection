#!/bin/bash

# Дефолты
DB_NAME="postgres"
PG_USER="postgres"
CONTAINER=""
TABLES_INPUT=""
OUT_PREFIX="tables-backup"

while getopts "n:u:c:t:o:" opt; do
  case $opt in
    n) DB_NAME="$OPTARG" ;;
    u) PG_USER="$OPTARG" ;;
    c) CONTAINER="$OPTARG" ;;
    t) TABLES_INPUT="$OPTARG" ;; # Список таблиц или маска, напр: "api_* users"
    o) OUT_PREFIX="$OPTARG" ;;   # Префикс имени файла
    *) echo "Usage: $0 -t <tables> [-n <db>] [-u <user>] [-c <container>] [-o <prefix>]"; exit 1 ;;
  esac
done

if [ -z "$TABLES_INPUT" ]; then
  echo "Ошибка: Укажите таблицы через -t (например: -t 'api_*' или -t 'table1 table2')"
  exit 1
fi

# Преобразуем строку таблиц в формат для pg_dump (-t "t1" -t "t2" ...)
TABLE_FLAGS=""
for t in $TABLES_INPUT; do
  TABLE_FLAGS="$TABLE_FLAGS -t $t"
done

DATE_STR=$(date +%d-%m-%Y_%H_%M_%S)
FILE_NAME="${OUT_PREFIX}_${DATE_STR}.backup"

echo "--- Table Backup started ---"

if [ -n "$CONTAINER" ]; then
  # В Docker используем кастомный формат -Fc для сжатия
  docker exec "$CONTAINER" pg_dump -U "$PG_USER" -d "$DB_NAME" $TABLE_FLAGS -Fc > "$FILE_NAME"
else
  # Локально
  pg_dump -U "$PG_USER" -d "$DB_NAME" $TABLE_FLAGS -Fc -f "$FILE_NAME"
fi

if [ $? -eq 0 ]; then
  echo "Success: $FILE_NAME"
  ls -lh "$FILE_NAME"
else
  echo "--- FAILED ---"
  exit 1
fi
