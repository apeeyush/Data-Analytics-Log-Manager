$(function() {

  $("#js-analyze-filtered").click(function(){
    var data, is_valid;
    var btn = $(this);
    data = document.getElementById("body_data").value;
    try {
      JSON.parse(data);
      is_valid = true;
    } catch (_error) {
      is_valid = false;
    }
    if (is_valid) {
      btn.button('loading');
      $.ajax({
        type: "POST",
        url: "/api/filter",
        data: data,
        success: function(data) {
          doSingleTableAnalysis(data);
          btn.button('reset');
        },
        error: function(){
          alert("An error occured!");
          btn.button('reset');
        }
      });
    } else {
      alert("Invalid JSON");
    }
  });

  $("#js-analyze-grouped").click(function(){
    var data, is_valid;
    var btn = $(this);
    data = document.getElementById("body_data").value;
    try {
      JSON.parse(data);
      is_valid = true;
    } catch (_error) {
      is_valid = false;
    }
    if (is_valid) {
      btn.button('loading');
      $.ajax({
        type: "POST",
        url: "/api/group",
        data: data,
        success: function(data) {
          doGroupAnalysis(data);
          btn.button('reset');
        },
        error: function(){
          alert("An error occured!");
          btn.button('reset');
        }
      });
    } else {
      alert("Invalid JSON");
    }
  });

  $("#js-analyze-synthetic-data").click(function(){
    var data, is_valid;
    var btn = $(this);
    data = document.getElementById("body_data").value;
    try {
      JSON.parse(data);
      is_valid = true;
    } catch (_error) {
      is_valid = false;
    }
    if (is_valid) {
      btn.button('loading');
      $.ajax({
        type: "POST",
        url: "/api/synthetic_data",
        data: data,
        success: function(data) {
          doGroupAnalysis(data);
          btn.button('reset');
        },
        error: function(){
          alert("An error occured!");
          btn.button('reset');
        }
      });
    } else {
      alert("Invalid JSON");
    }
  });

  $("#js-analyze-transformed").click(function(){
    var btn = $(this);
    btn.button('loading');
    $.ajax({
      type: "POST",
      url: "/api/transform",
      data: $('#transformation_form').serialize(),
      success: function(data) {
        doGroupAnalysis(data);
        btn.button('reset');
      },
      error: function(){
        alert("An error occured!");
        btn.button('reset');
      }
    });
  });

  $("#js-analyze-measures").click(function(){
    var data, is_valid;
    var btn = $(this);
    data = document.getElementById("body_data").value;
    try {
      JSON.parse(data);
      is_valid = true;
    } catch (_error) {
      is_valid = false;
    }
    if (is_valid) {
      btn.button('loading');
      $.ajax({
        type: "POST",
        url: "/api/measures",
        data: data,
        success: function(data) {
          doSingleTableAnalysis(data);
          btn.button('reset');
        },
        error: function(){
          alert("An error occured!");
          btn.button('reset');
        }
      });
    } else {
      alert("Invalid JSON");
    }
  });

});
