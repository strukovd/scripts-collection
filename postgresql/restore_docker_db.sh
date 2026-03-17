#!/bin/bash

# Проверяем, передан ли аргумент (имя базы)
if [ -z "$1" ]; then
  echo "Ошибка: укажите имя файла."
  echo "Использование: $0 <имя_файла>"
  exit 1
fi

FILE_NAME=$1 # dump_14-03-2026_20_19_12.backup

docker exec -i pg pg_restore -v -U postgres -d ul --no-owner < ${FILE_NAME}

# docker exec -it pg vacuumdb -U postgres -a -Z
