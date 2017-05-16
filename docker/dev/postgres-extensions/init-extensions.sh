#!/bin/bash
#
# Configure postgres docker image to use the extensions we need
#
PG_CONF=/var/lib/postgresql/data/postgresql.conf

grep pg_stat_statements $PG_CONF

if [ $? != 0 ]; then
    echo "shared_preload_libraries = 'pg_stat_statements'" >> $PG_CONF
fi

