#!/bin/bash
#
# Run this app in a docker container
#

DB_INIT_FILE=config/db.initialized
PID_FILE=tmp/pids/server.pid

#
# Install gems
#
bundle check || bundle install

#
# Install node packages
#
npm install

if [ ! -f $DB_INIT_FILE ]; then
    bundle exec rake db:migrate
    touch $DB_INIT_FILE
fi

if [ -f $PID_FILE ]; then
    rm -rf $PID_FILE
fi

bundle exec rails s -b 0.0.0.0

