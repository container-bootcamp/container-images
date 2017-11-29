#!/usr/bin/env bash

set -e

DB_HOST=${DB_HOST:?"DB_HOST is required"}
DB_SUPERUSER=${DB_SUPERUSER:?"DB_SUPERUSER is required"}
DB_SUPERUSER_PASSWORD=${DB_SUPERUSER_PASSWORD:?"DB_SUPERUSER_PASSWORD is required"}

echo ${DB_HOST}":*:*:"${DB_SUPERUSER}":"${DB_SUPERUSER_PASSWORD} > ~/.pgpass
chmod 0600 ~/.pgpass

psql=( psql -v ON_ERROR_STOP=1 )
psql+=( --username ${DB_SUPERUSER} --host ${DB_HOST})

echo
for file in /pg-init/*; do
    case ${file} in
        *.sh)     echo "$0: running ${file}"; . ${file} ;;
        *.sql)    echo "$0: running ${file}"; "${psql[@]}" -f ${file}; echo ;;
        *.sql.gz) echo "$0: running ${file}"; gunzip -c ${file} | "${psql[@]}"; echo ;;
        *)        echo "$0: ignoring ${file}" ;;
    esac
    echo
done

exec "$@"