#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Использование: $0 <имя_файла> <имя_целевой_бд>"
  exit 1
fi

FILE_NAME=$1
TARGET_DB=$2
PG_USERNAME="postgres"

# Если нужен пароль, раскомментируй строку ниже:
# export PGPASSWORD='ваш_пароль'

echo "--- Restore started ---"

# -v (verbose), -c (clean перед восстановлением, опционально)
pg_restore -U ${PG_USERNAME} -d ${TARGET_DB} --no-owner -v "${FILE_NAME}"

if [ $? -eq 0 ]; then
  echo "--- Restore finished successfully ---"
  # vacuumdb -U ${PG_USERNAME} -d ${TARGET_DB} -Z
else
  echo "--- Restore FAILED ---"
  exit 1
fi
