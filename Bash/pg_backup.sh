#!/bin/bash

#ENV

ENV_FILE="/opt/docker_compose_service/.env"

DB_HOST="locahost"

BACKUP_DIR="/opt/backup_db"
BACKUP_FILE="$BACKUP_DIR/pg_dump_$(date +%Y%m%d_%H%M%S).sql"

LAST_BACKUP=$(ls -t "$BACKUP_DIR" | head -n1)

DB_USER="testuser"
DB_NAME="testdb"

DOCKER_COMPOSE_PATH="/opt/docker_compose_service/docker-compose.yml"
CONTAINER_NAME=$(docker ps --format "{{.Names}}" | grep postgres)


# Устанавливаем переменные из .env,
# ибо при запуске скрипта он их обязательно требует
# всё потому, что мы в docker-compose их указали как обязательные

set -a
source "$ENV_FILE"
set +a

# Создание каталога под бэкап.

mkdir -p "$BACKUP_DIR"

# Создаем дамп БД

echo "Создаём бекап бд $DB_NAME..."
docker-compose -f "$DOCKER_COMPOSE_PATH" exec -T "$CONTAINER_NAME" pg_dump  -U "$DB_USER" -d "$DB_NAME" -f "/tmp/backup.sql"

# Копируем из контейнера на хост
docker cp "$CONTAINER_NAME:/tmp/backup.sql" "$BACKUP_FILE"

# Размер последнего бекапа.

echo "Размер последнего бекапа"
du -sh "$BACKUP_DIR/$LAST_BACKUP" | awk '{print $1}'

# Проверка свободного места диске после бекапа.

echo "Доступно место на диске"
df -h "$BACKUP_DIR" | awk '{print $4}' | tail -n1


# Автоматизация с помощью cron
# crontab -e
# 0 1 * * * /opt/scripts/pg_backup.sh

# Для стягивания на исходну машину
# ssh -i ~/.ssh/<ssh_key>  <user>@<ip>:/opt/backup_db/pg_dump_20250430_152346.sql  C:\Users\<user>\Desktop\pg_dump_20250430_152346.sql
