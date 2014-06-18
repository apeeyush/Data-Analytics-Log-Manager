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

});