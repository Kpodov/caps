#!/bin/bash

# a crontab will be updating this script

set -e
set -u

# dbsuri: name of database; lure_name: table in the db; data: column name in the table
#RUN_PSQL="psql -U postgres -f table.sql  -h localhost -p 5432 dbsuri -c "COPY lure_name (data) FROM STDIN;""
RUN_ON_MYDB="psql -U postgres -h localhost -p 5432 --set ON_ERROR_STOP=on dbsuri"
$RUN_ON_MYDB <<SQL
CREATE TABLE lure_name_tst1 (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ingested_at timestamp DEFAULT CURRENT_TIMESTAMP,
    data jsonb NOT NULL
);
SQL

# data.json will be replace by eve.json
cat data.json \
| \
psql -U postgres -h localhost -p 5432 dbsuri -c "COPY lure_name_tst1 (data) FROM STDIN;"


echo "sql script successful"
exit 0
