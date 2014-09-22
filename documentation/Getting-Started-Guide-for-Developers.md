---
layout: page
title: Getting Started Guide for Developers
permalink: /documentation/getting-started-dev/index.html
---


The Data Analytics Log Manager is a Rails Application. It uses [CODAP](https://github.com/concord-consortium/codap) for analytics visualization.

### Application Structure

CODAP is a SproutCore Application. It's built version resides in `public` folder under `static` and `codap`.

### Log Management

The logs are stored in table `logs`. Schema for the table is as follows:

    "session"      string
    "username"     string
    "application"  string
    "activity"     string
    "event"        string
    "time"         datetime
    "parameters"   hstore
    "extras"       hstore
    "created_at"   datetime
    "updated_at"   datetime
    "event_value"  string

The application is being designed such that changing the schema should require minimal changes in code.

[hstore](http://www.postgresql.org/docs/9.1/static/hstore.html) is PostgreSQL's key-value storage and all the key-value pairs other than the main columns are stored in either parameters or extras.

### User Management

The application has two tables : `admins` and `users`. Devise is used for authentication.

### Working with CODAP

The CODAP build code is included in the public folder. If you would like to update it, follow the instructions outlined [here](../updating_CODAP).