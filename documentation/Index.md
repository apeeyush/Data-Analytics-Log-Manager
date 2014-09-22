---
layout: page
title: Documentation
permalink: /documentation/index.html
---

Data Analytics Log Manager provides the following:

1. An API for receiving log data from multiple applications and storing them in a database (currently PostgreSQL).

2. Tools to analyse this data. It is possible to filter the data, create a parent-child relationship (by let's say grouping the data by username and visualizing logs for various usernames as child tables), add synthetic/computed data (let's say the number of times the user performed a particular action) etc.

### Sending Log Data :

A description of the API for sending Log Data to Log Manager is available [here](api).

### Analysing Logs :

Log Manage consists of the following components to help user transform data before analysis:

* **Filter:**

There may be millions of logs stored in the Database but you may be interested in analyzing only a subset of them. This first component enables you to select this subset of interest by specifying filters. A description of the same is available [here](filter).

* **Group:**

Let's say you have logs with a username/session key which you use to identify the particular user or session the log corresponds to. The Group component allows you to group the logs by a key (username/session etc.) such that a parent-child relationship is created where the parent table contains the group properties (such as the key's value[username], Count of a particular event for that username etc.) and the child tables contains the logs corresponding to the groups (For example logs corresponding to "anon_user" username will form a child table). A description of the same is available [here](group).

* **Filter Child Data:**

Let's say we don't want to see all logs corresponding to the group in the child table. We may be interested in just "Completed challenge". This can be done using filter child data component. A description of the same is available [here](filter-child-data).

* **Measures:**

Let's say we want to add some measures (such as number of times the user performed event "Bred dragons") after the data has been grouped. This can be done using the measures component. A description of the same is available [here](measures).

### Contributing:

**Project Setup**

To setup the project in your development environment, follow the instructions outlined [here](setup-instructions).

**Getting Started**

See the [Getting Started Guide for Developers](getting-started-dev) for more information about the technical working of Data Analytics Log Manager.

The style guide for the project is available [here](style-guide).

Feel free to fork the repository and hack on it! Implemented some feature? Well, just send a pull request. Facing problems setting things up or thought of a feature that may be useful for everybody? Contact us or open github issues for questions, bugs, feature requests etc.

Not sure how to start? Email us and let us know you're interested, and what you can do, and we'll figure out something you can help with.