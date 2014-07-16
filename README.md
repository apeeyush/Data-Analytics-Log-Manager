Data Analytics Log Manager
========

[![Build Status](https://travis-ci.org/apeeyush/Data-Analytics-Log-Manager.svg?branch=master)](https://travis-ci.org/apeeyush/Data-Analytics-Log-Manager)
[![Code Climate](https://codeclimate.com/github/apeeyush/Data-Analytics-Log-Manager.png)](https://codeclimate.com/github/apeeyush/Data-Analytics-Log-Manager)

Data Analytics Log Manager provides an API for receiving log data from multiple applications and storing them in a database. The data can then be transformed to create a parent-child relationship. It is also possible to add synthetic/computed data before visualizing it on [CODAP](https://github.com/concord-consortium/codap). More information about the project is available on [wiki](https://github.com/apeeyush/Data-Analytics-Log-Manager/wiki).

You may find it useful if you have an application for which you would like to visualize how your users are using it and find patterns hidden in the data. And what's more, it's all real time.

Motivation
--------
Existing Web Analytics tools, like Google Analytics, do not provide logging data at the individual-user data, and so are not usable for certain kinds of analytics. Many of The Concord Consortium's projects would like to capture detailed logs of actions students take in browser-based activities. Also, many other HTML5 projects would like to do analytics on event-based user data. The application will act as a shared tool for logging the data, transforming it and using CODAP for visualization.

Project Setup
--------
Install Rails 4.1 and make sure that you are running PostgreSQL 9.2 or higher on your system. Next clone the repository. Run `bundle install` from terminal after changing directory to the project directory.

Setup the `config/database.yml` file to allow the Rails application to connect to PostgreSQL. Either update the `username` and `password` with your existing user's value or create a new user in PostgreSQL having `username`:`log_manager` and `password`:`log_manager`. Now, create database `log_manager_development` and grant this user all privileges on `log_manager_development` database or make it a superuser.

Run `rake db:migrate` to apply migrations and after that you can start the rails server by using `rails server`. The rails console can be accessed using `rails console`.

Contributing
--------
Feel free to fork the repository and hack on it! Implemented some feature? Well, just send a pull request. Facing problems setting things up or thought of a feature that may be useful for everybody? Contact us or open github issues for questions, bugs, feature requests etc.

Not sure how to start? Email us and let us know you're interested, and what you can do, and we'll figure out something you can help with.
