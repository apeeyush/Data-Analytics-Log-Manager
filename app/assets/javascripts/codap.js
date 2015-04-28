// Used to put data having a parent-child relationship to CODAP via Data Interactive API
// Expects a hash in data with two keys
//   "template" :
//     "parent_keys" : [List of parent keys]
//     "child_keys"  : [List of child keys]
//   "groups" :
//     "parent_name" :
//       "parent_values" : [List of parent values]
//       "child_values"  : [Arrar of Array where each array is a list of child values]

var codapPhone = new iframePhone.IframePhoneRpcEndpoint(function() {}, "codap-game", window.parent);

function doGroupAnalysis(data) {
  var parent_keys = data.template.parent_keys;
  var child_keys = data.template.child_keys;
  var kParentCollectionName = "Parent Table";
  var kChildCollectionName = "Child Table";
  var kParentAttributeList = [];
  var kChildAttributeList = [];

  // Computes ParentAttributeList and ChildAttributeList to be sent to CODAP
  for (var i = 0; i < parent_keys.length; i++) {
    kParentAttributeList.push({ name : parent_keys[i] });
  }
  if (child_keys){
    for (i = 0; i < child_keys.length; i++) {
      kChildAttributeList.push({ name : child_keys[i] });
    }
  }

  codapPhone.call({
    action: 'reset'
  });

  codapPhone.call({
    action: 'initGame',
    args: {
      name: "DataInteractive",
      dimensions: { width: 600, height: 400 },
    }
  });

  codapPhone.call({
    action: 'createCollection',
    args: {
      name: kParentCollectionName,
      attrs: kParentAttributeList,
      childAttrName: kChildCollectionName,
      log: false
    }
  });

  codapPhone.call({
    action: 'createCollection',
    args: {
      name: kChildCollectionName,
      attrs: kChildAttributeList,
      log: false
    }
  });

  Object.keys(data.groups).forEach(function (key) {
    var value = data.groups[key];
    var children = value.child_values;
    var parent_values = value.parent_values;
    codapPhone.call({
      action: 'createCase',
      args: {
        collection: kParentCollectionName,
        values: parent_values
      }
    }, function(result) {
      var caseID = result.caseID;
      codapPhone.call({
        action: 'createCases',
        args: {
          collection: kChildCollectionName,
          parent: caseID,
          values: children
        }
      });
    });
  });
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
  var kParentCollectionName = "Parent Table";

  codapPhone.call({
    action: 'reset'
  });

  codapPhone.call({
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
  for (var i=0; i<data.template.length; i++){
    attrs_obj.push({ name: data.template[i] });
  }

  codapPhone.call({
    action: "createCollection",
    args: {
      name: kParentCollectionName,
      attrs: attrs_obj,
      log: false
    }
  });

  codapPhone.call({
    action: "createCases",
    args: {
      collection: kParentCollectionName,
      values: data.values
    }
  }, function() {
      codapPhone.call({
      action: 'createComponent',
      args: {
        type: 'DG.TableView',
        log: false
      }
    });
  });
}