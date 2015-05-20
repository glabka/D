#!/bin/bash
# run sql file (first parameter) in database specified by $OSD_DB
mysql -u "$OSD_USERNAME" -D "$OSD_DB" --password="$OSD_PASSWORD" < "$1"
echo "DONE"
