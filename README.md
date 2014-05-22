Data Analytics
========

The Rails application servers as a common system for sending user action logging data from various applications into visualization application CODAP after applying transformations.

Motivation
--------
Existing Web Analytics tools, like Google Analytics, do not provide logging data at the individual-user data, and so are not usable for certain kinds of analytics. Many of The Concord Consortium's projects would like to capture detailed logs of actions students take in browser-based activities. Also, many other HTML5 projects would like to do analytics on event-based user data. The application will act as a shared tool for logging the data, transforming it and sending it to CODAP for visualization.

Project Setup
--------
Install Rails 4.1 and make sure that you are running PostgreSQL 9.1 or higher on your system. Next clone the repository. Run `bundle install` from terminal after changing directory to the project directory.

Set up the `config/database.yml` file to allow the Rails application to connect to PostgreSQL. Either update the `username` and `password` with your existing user's value or create a new user in PostgreSQL having a `username` of `log_manager`. Now, grant this user all privileges on `log_manager_development` database or make it a superuser.

Run `rake db:migrate` to apply migrations and after that you can start the rails server by using `rails server`. The rails console can be accessed using `rails console`.

Contributing
--------
Fork the repository. You can send pull request if you would like to contribute some code. You can also open github issues for bugs.