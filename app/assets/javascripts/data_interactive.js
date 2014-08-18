$(function() {

  // Used to send Data Query from Data Interactive (CODAP)
  $("#js-submit-query").click(function(){
    var btn = $(this);
    btn.button('loading');
    var query = $("#json-textarea").val();
    var parsed_query = JSON.parse(query);
    if ( parsed_query.group.length === 0) {
      $.ajax({
        type: "POST",
        url: "/table_transform",
        data: $('#transformation_form').serialize(),
        success: function(data) {
          doSingleTableAnalysis(data);
          btn.button('reset');
        },
        error: function() {
          alert("An error occured!");
          btn.button('reset');
        }
      });
    } else {
      $.ajax({
        type: "POST",
        url: "/group_transform",
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
    }
  });

  // Used to save Data Query from Data Interactive (CODAP)
  $("#js-save-query").click(function(){
    var query = $("#json-textarea").val();
    var parsed_query = JSON.parse(query);
    $.ajax({
      type: "POST",
      url: "/data_queries/save",
      data: $('#transformation_form').serialize(),
      success: function(data) {
        alert('data saved successfully')
      },
      error: function() {
        alert("An error occured!");
      }
    });
  });

  // Enable TAB functionality on TextArea which shows JSON Query
  $(function() {
    enableTab('json-textarea');
  });

});
