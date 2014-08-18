Data Analytics Log Manager
========

[![Build Status](https://travis-ci.org/apeeyush/Data-Analytics-Log-Manager.svg?branch=master)](https://travis-ci.org/apeeyush/Data-Analytics-Log-Manager)
[![Code Climate](https://codeclimate.com/github/apeeyush/Data-Analytics-Log-Manager.png)](https://codeclimate.com/github/apeeyush/Data-Analytics-Log-Manager)

Data Analytics Log Manager helps collect log data and provides tools to analyze this data.

It provides a lot of flexibility on the type of log data. A single log entry can contain multiple arbitrary key value pairs (Let's say `"application" => "Test App"`, `"event" => "Clicked on Wiki"` and so on). The analytics tools are powerful as well as easy to use. We aim to make complex analytics easy for not only programmers but also other users such as researchers, managers, designers etc. who may not have prior exposure to programming.

Data Analytics Log Manager provides the following:

1. An API for receiving log data from multiple applications and storing them in a database (currently PostgreSQL).

2. Tools to analyse this data. It is possible to filter the data, create a parent-child relationship (by let's say grouping the data by username and visualizing logs for various usernames as child tables), add synthetic/computed data (let's say the number of times the user performed a particular action) etc.

More information about the project is available on [wiki](https://github.com/apeeyush/Data-Analytics-Log-Manager/wiki).

You may find it useful if you have an application for which you would like to visualize how your users are using it and find patterns hidden in the data.

Motivation
--------
Existing Web Analytics tools, like Google Analytics, do not provide logging data at the individual-user data, and so are not usable for certain kinds of analytics. Many of The Concord Consortium's projects would like to capture detailed logs of actions students take in browser-based activities. Also, many other HTML5 projects would like to do analytics on event-based user data. The application will act as a shared tool for logging the data, transforming it and using CODAP for visualization.

Project Setup
--------

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

Contributing
--------

See the [Getting Started Guide for Developers](https://github.com/apeeyush/Data-Analytics-Log-Manager/wiki/Getting-Started-Guide-for-Developers) for more information about the technical working of Data Analytics Log Manager.

The style guide for the project is available [here](https://github.com/apeeyush/Data-Analytics-Log-Manager/wiki/Style-Guide).

Feel free to fork the repository and hack on it! Implemented some feature? Well, just send a pull request. Facing problems setting things up or thought of a feature that may be useful for everybody? Contact us or open github issues for questions, bugs, feature requests etc.

Not sure how to start? Email us and let us know you're interested, and what you can do, and we'll figure out something you can help with.
