---
layout: page
title: Filter
permalink: /documentation/filter/index.html
---


A filter has the following components:

1. key
2. list
3. remove

Here, `key` is the name of field on which you want to apply filter. Eg. 'application', 'event' or 'starsCount'. `list` is a list of values you would like to include in the filtered data. For eg. to get just those logs where application is Geniverse, list will contain single entry 'Geniverse'.

A time based filter is slightly different and has the following components:

1. key
2. start_time
3. end_time

Here, `key` is the name of time column on which you want to apply filter. Eg. 'tine' or 'created_at'. `start_time` and `end_time` denote the starting and ending time and filtered logs will be within this time range. Eg. start_time could be '2014-04-10 08:00:00' etc.

**JSON format for Filter Query:**

    "filter" : [
      {
        "key"  : "activity"
        "list" : [list of activities]
        "type" : remove,                                 // Optional (Add for filter out)
        "filter_type": "string"                          // Optional (Prediction done at server side using database)
      },
      {
        "key" : "application"
        "list" : [list of applications]
        "type" : remove,                                 // Optional (Add for filter out)
        "filter_type": "string"                          // Optional (Prediction done at server side using database)
      },
      {
        "key" : "username",
        "list" : [list of usernames]
        "type" : remove,                                 // Optional (Add for filter out)
        "filter_type": "string"                          // Optional (Prediction done at server side using database)
      },
      {
        "key" : "time",
        "start time" : "2014-04-10 00:00:00",
        "end time" : "2014-05-10 00:00:00"
        "filter_type": "time"                          // Optional (Prediction done at server side using database)
      }
    ]