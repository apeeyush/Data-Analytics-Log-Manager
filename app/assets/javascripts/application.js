// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require dataTables/jquery.dataTables
//= require bootstrap


// Used to put data having a parent-child relationship to CODAP via Data Interactive API
// Expects a hash in data with two keys
//   "template" :
//     "parent_keys" : [List of parent keys]
//     "child_keys"  : [List of child keys]
//   "groups" :
//     "parent_name" :
//       "parent_values" : [List of parent values]
//       "child_values"  : [Arrar of Array where each array is a list of child values]
function doGroupAnalysis(data) {
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

  window.parent.DG.doCommand({
    action: 'initGame',
    args: {
      name: "DataInteractive",
      dimensions: { width: 600, height: 400 },
    }
  });
  window.parent.DG.doCommand({
    action: 'createCollection',
    args: {
      name: kParentCollectionName,
      attrs: kParentAttributeList,
      childAttrName: kChildCollectionName,
      log: false
    }
  });
  window.parent.DG.doCommand({
    action: 'createCollection',
    args: {
      name: kChildCollectionName,
      attrs: kChildAttributeList,
      log: false
    }
  });

  Object.keys(data["groups"]).forEach(function (key) {
    var value = data["groups"][key];
    var children = value["child_values"];
    var parent_values = value["parent_values"];
    result = window.parent.DG.doCommand( {
      action: 'createCase',
      args: {
        collection: kParentCollectionName,
        values: parent_values
      }
    });
    var caseID = result["caseID"]
    window.parent.DG.doCommand( {
      action: 'createCases',
      args: {
        collection: kChildCollectionName,
        parent: caseID,
        values: children
      }
    });
  })
}

// Sample Data Format for doSingleTableAnalysis Function
// var data = new Object();
// data['template'] = ["columne_1", "column_2"];
// data['values'] = [
//   ["child_1_value_1", "child_1_value_2"],
//   ["child_1_value_1", "child_1_value_2"],
//   ["child_1_value_1", "child_1_value_2"]
// ];
function doSingleTableAnalysis(data){
  var kParentCollectionName = "Parent Table"
  window.parent.DG.doCommand({
    action: "initGame",
    args: {
      name: "DataInteractive",
      dimensions: {
        width: 600,
        height: 400
      }
    }
  });
  var attrs_obj = [];
  for (var i=0; i<data["template"].length; i++){
    attrs_obj.push({ name: data["template"][i] });
  }
  window.parent.DG.doCommand({
    action: "createCollection",
    args: {
      name: kParentCollectionName,
      attrs: attrs_obj,
      log: false
    }
  });
  window.parent.DG.doCommand({
    action: "createCases",
    args: {
      collection: kParentCollectionName,
      values: data['values']
    }
  });
}