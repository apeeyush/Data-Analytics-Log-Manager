var attrs = [];
var attrs_obj = [];
var cases = [];
var single_case = []
var Analytics = {

  controller: window.parent.DG,

  analyze: function() {
    // console.log("I am inside analyze function.");
    var this_ = this;
    $.ajax({ 
      type: 'GET',
      url: 'http://log-manager.herokuapp.com/api/logs',
      // url: 'http://localhost:3000/api/logs',
      success: function(data){
        this_.doAnalysis(data)
      }
    });
  },

  analyze_filtered: function() {
    // var data = {
    //   "filter" : {
    //     "event" : ["Changed allele"]
    //   }
    // };
    data = document.getElementById("body_data").value;
    try {
      JSON.parse(data);
      var is_valid = true
    } catch (e) {
      var is_valid = false
        console.log("Invalid");
    }
    if (is_valid){
      var this_ = this;
      console.log(JSON.stringify(data));
      $.ajax({ 
        type: "POST",
        url: "http://log-manager.herokuapp.com/api/filter",
        // url: "http://localhost:3000/api/filter",
        data: data,
        success: function(data){
          this_.doAnalysis(data)
        }
      });
    }
    else{
      alert("Invalid JSON");
    }
  },

  doAnalysis: function(data) {

    // console.log("I am inside do Analytics Function");
    var this_ = this,
        kParentCollectionName = 'Logs';

    for (var key in data) {
      if (data.hasOwnProperty(key)) {
        for ( var k in data[key] ){
          if($.inArray(k, attrs) <= -1){
            attrs.push(k);
            attrs_obj.push({name: k});
          }
        }
      }
    }

    for (var key in data) {
      if (data.hasOwnProperty(key)){
        single_case = [];
        for (var i = 0; i < attrs.length; i++) {
          if(attrs[i] in data[key]){
            if (typeof(data[key][attrs[i]]) === "object")
              single_case.push( JSON.stringify( data[key][attrs[i]] ) );
            else
              single_case.push( data[key][attrs[i]] );
          }else{
            single_case.push("");
          }
        }
        cases.push(single_case);
      }
    }

    this_.controller.doCommand( {
      action: 'initGame',
      args: {
        name: "DataInteractive",
        dimensions: { width: 450, height: 200 },
      }
    });

    this_.controller.doCommand( {
      action: 'createCollection',
      args: {
        name: kParentCollectionName,
        attrs: attrs_obj,
        log: false
      }
    });

    this_.controller.doCommand( {
      action: 'createCases',
      args: {
        collection: "Logs",
        values: cases
      }
    });
  }
};