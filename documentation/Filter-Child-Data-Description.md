---
layout: page
title: Filter Child Data
permalink: /documentation/filter-child-data/index.html
---


Check the "Add Child Data" checkbox to indicate that you would like to import child data to CODAP. To specify filters on the child data, you can add String or Time filters that will be applied only for fetching specified data.


**JSON format for Child Query:**

    "child_query": {
      "add_child_data": true
      "filter": [
        {
          "key": "key1",
          "list": [
            "value1"
          ],
          "remove": false,
          "filter_type": "string"
        },...
      ]
    }
