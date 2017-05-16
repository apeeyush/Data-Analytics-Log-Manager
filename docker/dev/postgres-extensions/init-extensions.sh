#!/bin/bash
#
# Configure postgres docker image to use the extensions we need
#

#
# Run "set +e" because these init scrupts seem to run "set -e" by default,
# which doesn't allow us to check exit failures from grep or otherwise.
#
set +e

PG_CONF=/var/lib/postgresql/data/postgresql.conf

grep pg_stat_statements $PG_CONF

if [ $? != 0 ]; then
    echo "Adding pg_stat_statements to config ..."
    echo "shared_preload_libraries = 'pg_stat_statements'" >> $PG_CONF
fi

