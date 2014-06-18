var Analytics, controller;

$(function() {

  $("#js-submit-query").click(function(){
    var data, is_valid, _error;
    is_valid = true;
    // try {
    //   JSON.parse(data);
    //   is_valid = true;
    // } catch (_error) {
    //   is_valid = false;
    // }
    if ( $("#js-group-data").val().length == 0) {
      $.ajax({
        type: "POST",
        url: "/api/table_transform",
        data: $('#transformation_form').serialize(),
        success: function(data) {
          doSingleTableAnalysis(data);
        }
      });
    } else {
      $.ajax({
        type: "POST",
        url: "/api/group_transform",
        data: $('#transformation_form').serialize(),
        success: function(data) {
          doGroupAnalysis(data);
        }
      });
    }
  });

});