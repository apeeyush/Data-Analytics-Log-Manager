var Analytics, controller;

window.analyze = function() {
  $.ajax({
    type: "GET",
    url: "/api/logs",
    success: function(data) {
      Analytics.doAnalysis(data);
    }
  });
};

window.analyzeFiltered = function() {
  var data, is_valid, _error;
  data = document.getElementById("body_data").value;
  try {
    JSON.parse(data);
    is_valid = true;
  } catch (_error) {
    is_valid = false;
  }
  if (is_valid) {
    $.ajax({
      type: "POST",
      url: "/api/filter",
      data: data,
      success: function(data) {
        Analytics.doAnalysis(data);
      }
    });
  } else {
    alert("Invalid JSON");
  }
};

window.analyzeGrouped = function() {
  var data, is_valid, _error;
  data = document.getElementById("body_data").value;
  try {
    JSON.parse(data);
    is_valid = true;
  } catch (_error) {
    is_valid = false;
  }
  if (is_valid) {
    $.ajax({
      type: "POST",
      url: "/api/group",
      data: data,
      success: function(data) {
        Analytics.doGroupAnalysis(data);
      }
    });
  } else {
    alert("Invalid JSON");
  }
};

window.analyzeTransformed = function() {
  var data, is_valid, _error;
  data = document.getElementById("body_data").value;
  try {
    JSON.parse(data);
    is_valid = true;
  } catch (_error) {
    is_valid = false;
  }
  if (is_valid) {
    $.ajax({
      type: "POST",
      url: "/api/transform",
      data: data,
      success: function(data) {
        Analytics.doGroupAnalysis(data);
      }
    });
  } else {
    alert("Invalid JSON");
  }
};

controller = window.parent.DG;

Analytics = {
  controller: window.parent.DG,

  doGroupAnalysis: function(data) {
    var this_ = this;
    var parent_keys = data.template.parent_keys;
    var child_keys = data.template.child_keys;
    var kParentCollectionName = "Parent Table";
    var kChildCollectionName = "Child Table"
    var kParentAttributeList = []
    var kChildAttributeList = []

    // Computes ParentAttributeList and ChildAttributeList to be sent to CODAP
    for (var i = 0; i < parent_keys.length; i++) {
      kParentAttributeList.push({ name : parent_keys[i] });
    }
    for (var i = 0; i < child_keys.length; i++) {
      kChildAttributeList.push({ name : child_keys[i] });
    }

    this_.controller.doCommand( {
      action: 'initGame',
      args: {
        name: "DataInteractive",
        dimensions: { width: 600, height: 400 },
      }
    });

    this_.controller.doCommand( {
      action: 'createCollection',
      args: {
        name: kParentCollectionName,
        attrs: kParentAttributeList,
        childAttrName: kChildCollectionName,
        log: false
      }
    });

    this_.controller.doCommand( {
      action: 'createCollection',
      args: {
        name: kChildCollectionName,
        attrs: kChildAttributeList,
        log: false
      }
    });

    for ( var i=0; i < data.groups.length; i++){

      var children = data.groups[i][data.groups[i].length - 1].children;
      var parent_values = data.groups[i].slice(0, data.groups[i].length - 1);
      result = this_.controller.doCommand( {
        action: 'createCase',
        args: {
          collection: kParentCollectionName,
          values: parent_values
        }
      });
      var caseID = result["caseID"]
      this_.controller.doCommand( {
        action: 'createCases',
        args: {
          collection: kChildCollectionName,
          parent: caseID,
          values: children
        }
      });
    }
  },

  doAnalysis: function(data) {
    var i, k, kParentCollectionName, key, this_, attrs, attrs_obj, all_log_cases, single_log_case;
    attrs = [];
    attrs_obj = [];
    all_log_cases = [];       // Used to store logs which will then be passed to CODAP for visualization
    single_log_case = [];     // Used to store single log values during iteration through all logs
    key = void 0;
    this_ = this;
    kParentCollectionName = "Logs";

    // Parses the whole data to get the attribute list
    for (key in data) {
      if (data.hasOwnProperty(key)) {
        for (k in data[key]) {
          if ($.inArray(k, attrs) <= -1) {
            attrs.push(k);
            attrs_obj.push({ name: k });
          }
        }
      }
    }


    for (key in data) {
      if (data.hasOwnProperty(key)) {
        single_log_case = [];
        i = 0;
        while (i < attrs.length) {
          if (attrs[i] in data[key]) {
            if (typeof data[key][attrs[i]] === "object") {
              single_log_case.push(JSON.stringify(data[key][attrs[i]]));
            } else {
              single_log_case.push(data[key][attrs[i]]);
            }
          } else {
            single_log_case.push("");
          }
          i++;
          all_log_cases.push(single_log_case);
        }
      }
    }

    controller.doCommand({
      action: "initGame",
      args: {
        name: "DataInteractive",
        dimensions: {
          width: 600,
          height: 400
        }
      }
    });
    controller.doCommand({
      action: "createCollection",
      args: {
        name: kParentCollectionName,
        attrs: attrs_obj,
        log: false
      }
    });
    controller.doCommand({
      action: "createCases",
      args: {
        collection: "Logs",
        values: all_log_cases
      }
    });
  }
};
