$(function() {

  $("#js-submit-query").click(function(){
    var btn = $(this);
    btn.button('loading');
    if ( $("#js-group-data").val().length === 0) {
      $.ajax({
        type: "POST",
        url: "/api/table_transform",
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
        url: "/api/group_transform",
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

});