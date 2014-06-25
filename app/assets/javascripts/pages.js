jQuery(function() {
  $("#explore_application").on("change", function() {
    refresh();
  });
  $("#explore_activity").on("change", function() {
    refresh();
  });
});

function refresh() {
  $.ajax({
    type: "POST",
    url: "/pages/get_explore_data",
    data: $('#explore').serialize(),
    success: function(data) {
      $("#events-list").empty();
      $("#keys-list").empty();
      var eventsLength = data["events"].length;
      for (var i = 0; i < eventsLength; i++) {
        $("#events-list").append('<li>' + data["events"][i] + '</li>');
      }
      var keysLength = data["keys"].length;
      for (var i = 0; i < keysLength; i++) {
        $("#keys-list").append('<li>' + data["keys"][i] + '</li>');
      }
    }
  });

}