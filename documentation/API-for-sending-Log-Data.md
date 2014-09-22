---
layout: page
title: API for sending Log Data
permalink: /documentation/api/index.html
---

Sending log data to Rails application is as simple as sending HTTP Post request to the service. You can send a single log or multiple logs in a single Post request. 

A line of code speaks more than a thousand words. So here are two ways to send logs, one through the terminal and the other through the browser's console.

#### Sending Logs through your terminal

The example below sends a log to the application straight through your terminal.

    curl -H "Content-Type: application/json" -d '{"session":"api_test_session","username":"api_test_user","time":"1234561234560","application":"TestApplication","activity": "TestActivity","event":"Testing API","parameters":{"parameter1":"value1"} , "extrakey1":"extravalue1"}' https://log-manager.herokuapp.com/api/logs

Here is a post request for sending multiple log events which you can try sending from terminal.

    curl -H "Content-Type: application/json" -d '[{"session":"api_test_session","username":"api_test_user","time":"1234561234560","application":"TestApplication","activity": "TestActivity","event":"Testing API","parameters":{"parameter1":"value1"} , "extrakey1":"extravalue1"}, {"session":"api_test_session","username":"api_test_user","time":"1234561234560","application":"TestApplication","activity": "TestActivity","event":"Testing API","parameters":{"parameter1":"value1"} , "extrakey1":"extravalue1"}]' http://log-manager.herokuapp.com/api/logs

#### Sending Logs through your browser's console

The example below sends a log straight through your browser. In Chrome, use `Ctrl + Shift + J` (Windows/Linux) or `Cmd + Opt + J` (Mac) to open the console and execute the following.

    var data = {"session":"api_test_session","username":"api_test_user","time":"1234561234560","application":"TestApplication","activity": "TestActivity","event":"Testing API","parameters":{"parameter1":"value1"} , "extrakey1":"extravalue1"};
    var request = new XMLHttpRequest();
    request.open('POST', 'http://log-manager.herokuapp.com/api/logs', true);
    request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
    request.send(JSON.stringify(data));

Here is a post request for sending multiple log events which you can try sending from console.

    var data = [{"session":"api_test_session_1","username":"api_test_user","time":"1234561234560","application":"Multi Logs","activity":"TestActivity","event":"Event 1","parameters":{"parameter1":"value1","parameter2":"value2"} , "extrakey1":"extravalue1"}, {"session":"api_test_session_1","username":"api_test_user","time":"1234561234560","application":"Multi Logs","activity":"TestActivity","event":"Event 2","parameters":{"parameter1":"value1","parameter2":"value2"} , "extrakey1":"extravalue1"}];
    var request = new XMLHttpRequest();
    request.open('POST', 'http://log-manager.herokuapp.com/api/logs', true);
    request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
    request.send(JSON.stringify(data));


Note that you should try sending logs to your own Rails application. If you have set up a development environment, you may want to send the request to http://localhost:3000/api/logs instead of http://log-manager.herokuapp.com/api/logs.

### Log format

Currently, JSON format is supported by Rails application.You should pass the json encoded log in the body of the request.

A single log comprises of multiple key value pairs. Eg.

    {"session":"api_test_session", "username":"api_test_user", "time":"1234561234560", "application":"TestApplication", "activity": "TestActivity", "event":"Testing API", "parameters":{"parameter1":"value1"}, "extrakey1":"extravalue1"}

To send multiple logs in a single post request, just send an array where each entry corresponds to a log. Eg.

    [{"session":"api_test_session_1", "username":"api_test_user", "time":"1234561234560", "application":"TestApplication", "event":"Testing API"}, {"session":"api_test_session_2", "username":"api_test_user_2", "time":"1234561234560", "application":"TestApplication", "event":"Testing API"}]

#### Database Structure for storing Logs

    Table name: logs

    id          :integer          not null, primary key
    session     :string(255)
    username    :string(255)
    application :string(255)
    activity    :string(255)
    event       :string(255)
    time        :datetime
    parameters  :hstore
    extras      :hstore
    created_at  :datetime
    updated_at  :datetime
    event_value :string(255)

**Note:**

1. `session`, `username`, `application`, `activity`, `event` and `time` are indexed by default.
2. `extras` and `parameters` are hstore data type. It essentially allows storing multiple key-value pairs in a single column. More information about it is available [here](http://www.postgresql.org/docs/9.1/static/hstore.html) and [here](http://postgresguide.com/sexy/hstore.html).

#### Default API Behaviour:

* Values for `session`, `username`, `application`, `activity`, `event`, `time` and `event_value` are mapped directly from the corresponding value in log. So if the log contains `"username" : "test_user"`, then the log entry in database will also contain test_user as username.

* The `time` is expected to be a UTC timestamp.

* There are two hstore columns.
It may be really useful if you have some very important keys which you would like to index. You could put them in parameters and index that column.
The `parameters` key in the JSON body sent to the API is expected to contain the key-value pairs you would like to put in parameters column. For eg. `"parameters":{"parameter1":"value1","parameter2":"value2"}` will put `"parameter1":"value1"` and `"parameter2":"value2"` in parameters column.

* All other key value pairs present in the body are put in the extras column. So, if we have `"extrakey1":"extravalue1"` in the body, it will be stored in the extras column.


### HTTP response codes

**201 – Created**

Everything went smooth and your log(s) have been saved in the database.

**422 – Unprocessable Entity**

Something with the log message is not quite right (either malformed JSON or incorrect fields).

**500 – Internal Server Error**

As you may guess, this is because of some fault in the Rails application. Consider creating an issue on Github and we will fix it as soon as possible.