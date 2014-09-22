---
layout: page
title: Setup Instructions
permalink: /documentation/setup-instructions/index.html
---


## Setup Instructions:

### Install the following:
1. Rails 4.1+
2. PostgreSQL 9.2+

### Clone the repository:

    git clone https://github.com/apeeyush/Data-Analytics-Log-Manager.git

### Run the following commands:

    cd Data-Analytics-Log-Manager/
    bundle install

### Setup the database:

Setup the `config/database.yml` file to allow the Rails application to connect to PostgreSQL.

Either update the `username` and `password` with your existing user's value or create a new user in PostgreSQL having `username`:`log_manager` and `password`:`log_manager`. Now, create database `log_manager_development` and grant this user all privileges on `log_manager_development` database or make it a superuser.

### Run migrations on database:

    rake db:migrate

### Run application on localhost:

    rails server

To run rails console:

    rails console
 
### Configure Mailer:

A user can use Log Manager only after confirming the account. Hence, configuring mailer is required to test it successfully. To allow the rails application to send mails, update the `/config/environments/development.rb` or set environment variables `EMAIL` and `PASSWORD`.

One way to set it up in development environment it to add a file `config/initializers/app_env_vars.rb`. It's content should be:

    ENV['EMAIL'] = 'replace_with_your_email'
    ENV['PASSWORD'] = 'replace_with_your_password'

It has been added to `.gitignore` so your password will not be committed accidentally.

For more information, refer to [this](http://stackoverflow.com/a/13296207/2352321).