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
Existing Web Analytics tools, like Google Analytics, do not provide logging data at the individual-user data, and so are not usable for certain kinds of analytics. Many of the projects would like to capture detailed logs of actions users take in browser-based activities. The application will act as a shared tool for logging the data, transforming it and using [CODAP](https://github.com/concord-consortium/codap) for visualization.


Project Setup, Docker Compose option
--------

1. Clone the Log Manager repo. Optionally give the clone directory a more friendly name.
  > E.g.  
  `git clone https://github.com/concord-consortium/Data-Analytics-Log-Manager cc-log-manager`  

2. From the root directory of the cloned repo, run: 
  > `docker-compose up`
3. By default, the UI should be available to a browser at `http://localhost:3000/`



Project Setup, Docker Fig option
--------

This project includes a Dockerfile and a Fig (now [Docker Compose](http://blog.docker.com/2015/02/announcing-docker-compose/)) configuration that allows you to use containers based on prebuilt Rails and Postgres images, rather than having to install software
locally on your machine. (However, production deploys use Heroku rather than Docker images you build.)

1. Install and run [Docker](http://docker.com). Mac users will need to install and run [boot2docker] (http://boot2docker.io/) as well. Mac users can install these via Homebrew.
2. Install [fig](http://www.fig.sh/install.html). *Note: Docker Compose is an updated version of Fig, so the steps below should work much the same with Compose. However, these instructions were developed using Fig.*
3. Run `fig build` in the root of this project. This will pull the required images, run `bundle install`, etc.
4. To start the server and database containers, run `fig up` in the root of the project
5. Initialize the database: `fig run web bin/rake db:create db:migrate`
6. If you are using boot2docker, you will need to find the IP address of the server, like this: `boot2docker ip`
7. Visit `http://localhost:3000/` (or `http://<boot2docker ip>:3000/`, if appropriate) to run the app

The Fig configuration mounts the project folder as app root in the container. Thus, there is no special step to get your changes into the container (and running the app does not write to the `web` container's filesystem; logs and caches go into the mounted project folder, and database changes persist in the `db` container). Of course, you may need to `fig restart web` after making changes. However, gems are stored in the container, and there is a special step required when updating the Gemfile:

#### How to `bundle install` in the Docker container without rebuilding

The default Rails image ([`rails:onbuild`](https://github.com/docker-library/rails/blob/master/onbuild/Dockerfile)) freezes the bundle for deployment. If you try to change the `Gemfile` and run

    fig run web bundle install

to update `Gemfile.lock` and install the new gems into the `web` container, Bundler will tell you to try again with the `--no-deployment` flag. It's all a lie. Here's how to run `bundle install`:

1. `fig run web /bin/bash -c "bundle config frozen 0 && bundle install && bundle config frozen 1"`
2. `docker ps -a` and make a note of the name of the container that just stopped (each `fig run web` happens in a new container that "forks" the base `web` container)
3. `docker commit dataanalyticslogmanager_web_run_1 dataanalyticslogmanager_web` (where `dataanalyticslogmanager_web_run_1` is assumed to be the name of the recently run container, and `dataanalyticslogmanager_web` the image it uses). This step is necessary so that the next time Fig starts the web container, it uses the saved state of the `fig run web` step.
4. You can now `docker rm dataanalyticslogmanager_web_run_1`

#### If Fig gets confused

In order to get Fig to work correctly, I had to rename the project directory to `data_analytics_log_manager`; Fig got confused by the mixed case. This may have been fixed by now.

Project Setup, local install (no Docker)
------

### Install the following:
1. Rails 4.1+
2. PostgreSQL 9.2+

### Clone the repository:

    git clone https://github.com/apeeyush/Data-Analytics-Log-Manager.git

### Run the following commands:

    cd Data-Analytics-Log-Manager/
    cp config/database.sample.yml config/database.yml
    bundle install
    npm install

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

A user can use Log Manager only after confirming the account. By default, in development emails will be placed in files in tmp/mails.

If you would like to configure a more complex setup, set the following environment variables (see config/initializers/actionmailer.rb):

    # Required
    ENV["MAILER_DOMAIN_NAME"]     # your server's domain name
    ENV["MAILER_SMTP_HOST"]       # the SMTP host to send mail through
    ENV["MAILER_SMTP_USER_NAME"]  # the SMTP username you want to use
    ENV["MAILER_SMTP_PASSWORD"]   # the SMTP password you want to use

    #Optional
    ENV["MAILER_DELIVERY_METHOD"]             # defaults to :file, for production set it to "smtp"
    ENV["MAILER_SMTP_PORT"]                   # defaults to 587
    ENV["MAILER_SMTP_AUTHENTICATION_METHOD"]  # defaults to :login
    ENV["MAILER_SMTP_STARTTLS_AUTO"]          # defaults to true

Contributing
--------

See the [Getting Started Guide for Developers](https://github.com/apeeyush/Data-Analytics-Log-Manager/wiki/Getting-Started-Guide-for-Developers) for more information about the technical working of Data Analytics Log Manager.

The style guide for the project is available [here](https://github.com/apeeyush/Data-Analytics-Log-Manager/wiki/Style-Guide).

Feel free to fork the repository and hack on it! Implemented some feature? Well, just send a pull request. Facing problems setting things up or thought of a feature that may be useful for everybody? Contact us or open github issues for questions, bugs, feature requests etc.

Not sure how to start? Email us and let us know you're interested, and what you can do, and we'll figure out something you can help with.

License
--------
Data Analytics Log Manager is released under the [MIT License](http://opensource.org/licenses/MIT).

Attribution
--------
Data Analytics Log Manager started as a Google Summer of Code Project. The project was done by [Peeyush Agarwal](https://github.com/apeeyush) and [The Concord Consortium](http://concord.org/) was the mentoring organization.

