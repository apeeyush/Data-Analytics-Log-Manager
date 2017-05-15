#!/bin/bash
#
# Run this app in a docker container
#

DB_CONFIG=$APP_HOME/config/database.yml
PID_FILE=tmp/pids/server.pid

#
# Install gems
#
bundle check || bundle install

#
# Install node packages
#
npm install

if [ ! -f $DB_CONFIG ]; then
    cp $APP_HOME/config/database.sample.yml $DB_CONFIG
    bundle exec rake db:migrate
fi

if [ -f $PID_FILE ]; then
    rm -rf $PID_FILE
fi

bundle exec rails s -b 0.0.0.0 & bundle exec rake jobs:work

