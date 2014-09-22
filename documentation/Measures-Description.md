---
layout: page
title: Measures
permalink: /documentation/measures/index.html
---


Three types of Measures are supported by Data Analytics Log Manager currently.

1. Count
2. Sum
3. AddValue

**Count:**
Specify the name of measure in `name`. Add filters if you want to count only a subset of logs for each group. For eg. to just count logs where 'event' is 'Started Challenge', you can add a filter to filter those logs. Add `"measure_type": "count"` to indicate that it is a count measure.

**Sum:**
Specify the name of measure in `name`. The `key` parameter specifies the field whose value has to be added. For eg. if you want to add values of 'starsAwarded' for each user, key would be 'starsAwarded'. Add filters if you want to sum for a subset of logs for each group. For eg. to just add key values for logs where 'event' is 'Started Challenge 1', you can add a filter to filter those logs. Add `"measure_type": "sum"` to indicate that it is a sum measure.

**AddValue:**
Specify the name of measure in `name`. The `key` parameter specifies the field whose value (for the first occurrence) has to be added to parent table. For eg. if you want to add values of 'class' for each user, key would be 'class'. Add filters if you want to consider a subset of logs for each group. For eg. to just consider logs where 'event' is 'User Signed In', you can add a filter to filter those logs. Add `"measure_type": "value"` to indicate that it is a AddValue measure.

**The JSON format for Measures is:**

    "measures": [
      {
        "name": "count_measure",
        "filter": [],
        "measure_type": "count"
      },
      {
        "name": "sum_measure",
        "filter": [],
        "key": "key",
        "measure_type": "sum"
      },
      {
        "name": "value_measure",
        "filter": [],
        "key": "key",
        "measure_type": "value"
      },...
    ]