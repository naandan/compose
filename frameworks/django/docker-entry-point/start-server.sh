#!/usr/bin/env bash
# start-server.sh
cd web_apps

DB_WAIT_TIMEOUT=${DB_WAIT_TIMEOUT-3}
MAX_DB_WAIT_TIME=${MAX_DB_WAIT_TIME-30}
CUR_DB_WAIT_TIME=0

while ! ./manage.py migrate --no-input 2>&1 && [ "${CUR_DB_WAIT_TIME}" -lt "${MAX_DB_WAIT_TIME}" ]; do
  echo "⏳ Waiting on DB... (${CUR_DB_WAIT_TIME}s / ${MAX_DB_WAIT_TIME}s)"
  sleep "${DB_WAIT_TIMEOUT}"
  CUR_DB_WAIT_TIME=$(( CUR_DB_WAIT_TIME + DB_WAIT_TIMEOUT ))
done
if [ "${CUR_DB_WAIT_TIME}" -ge "${MAX_DB_WAIT_TIME}" ]; then
  echo "❌ Waited ${MAX_DB_WAIT_TIME}s or more for the DB to become ready."
  exit 1
fi

./manage.py collectstatic --no-input
python manage.py makemigrations
python manage.py migrate --no-input
python manage.py remove_stale_contenttypes --no-input
cp -r staticfiles_build/static/* static/

echo "✅ Initialisation is done."

nginx

exec $@
