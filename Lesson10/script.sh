#!/bin/bash

LOGFILE="/var/log/nginx/access.log"
ERRLOG="/var/log/nginx/error.log"
TEMP_FILE="/tmp/nginx_laststart"

LAST_RUN=$(cat "$TEMP_FILE" 2>/dev/null || echo 0)
CURRENT_POS=$(wc -c < "$LOGFILE")

LOGDATA=$(tail -c +$((LAST_RUN + 1)) "$LOGFILE")
ERRDATA=$(tail -c +$((LAST_RUN + 1)) "$ERRLOG")

echo "$CURRENT_POS" > "$TEMP_FILE"

REPORT=$(cat <<EOF
=====================================
Отчёт NGINX
=====================================

Список IP-адресов с наибольшим количеством запросов:
$(echo "$LOGDATA" | awk '{print $1}' | sort | uniq -c | sort -nr)

Список запрашиваемых URL с наибольшим количеством запросов:
$(echo "$LOGDATA" | awk '{print $7}' | grep -E '^/' | sort | uniq -c | sort -nr)

Ошибки веб-сервера:
$(echo "$ERRDATA" | grep -i "error" | sort | uniq -c | sort -nr || echo "Ошибок нет!")

Список всех кодов HTTP-ответов с указанием их количества:
$(echo "$LOGDATA" | awk '{print $9}' | grep -E '^[0-9]{3}$' | sort | uniq -c | sort -nr)

=====================================
EOF
)

echo "$REPORT" | mail -s "NGINX Report — $(date +'%Y-%m-%d %H:%M')" root

CRON_JOB="0 * * * * $(realpath "$0")"
(crontab -l 2>/dev/null | grep -Fq "$0") || (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

exit 0
 