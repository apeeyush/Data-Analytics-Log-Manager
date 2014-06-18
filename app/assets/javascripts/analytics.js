var Analytics, controller;

$(function() {

  $("#js-analyze").click(function(){
    $.ajax({
      type: "GET",
      url: "/api/logs",
      success: function(data) {
        doSingleTableAnalysis(data);
      }
    });
  });

  $("#js-analyze-filtered").click(function(){
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
          doSingleTableAnalysis(data);
        }
      });
    } else {
      alert("Invalid JSON");
    }
  });

  $("#js-analyze-grouped").click(function(){
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
          doGroupAnalysis(data);
        }
      });
    } else {
      alert("Invalid JSON");
    }
  });

  $("#js-analyze-transformed").click(function(){
    var data, is_valid, _error;
    is_valid = true;
    // try {
    //   JSON.parse(data);
    //   is_valid = true;
    // } catch (_error) {
    //   is_valid = false;
    // }
    if (is_valid) {
      $.ajax({
        type: "POST",
        url: "/api/transform",
        data: $('#transformation_form').serialize(),
        success: function(data) {
          doGroupAnalysis(data);
        }
      });
    } else {
      alert("Invalid JSON");
    }
  });

  $("#js-analyze-measures").click(function(){
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
        url: "/api/measures",
        data: data,
        success: function(data) {
          doSingleTableAnalysis(data);
        }
      });
    } else {
      alert("Invalid JSON");
    }
  });

});
