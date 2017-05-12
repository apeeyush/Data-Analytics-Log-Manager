#!/bin/bash
#
# Run this app in a docker container
#

DB_INIT_FILE=/config/db.initialized

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

bundle exec rails s -b 0.0.0.0

