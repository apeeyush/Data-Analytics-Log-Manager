jQuery(function() {
  var table;
  table = $('#logs').dataTable({
    "sPaginationType": "bootstrap",
    "pagingType": "full_numbers",
    "columns": [
    null,
    null,
    null,
    null,
    null,
    null,
    {"orderable": false},
    {"orderable": false},
    {"orderable": false}
    ],
    bProcessing: true,
    bServerSide: true,
    sAjaxSource: $('#logs').data('source'),
    fnServerParams: function(aoData) {
      var activityName, applicationName, endPeriod, startPeriod, timeZone;
      applicationName = $("#filter_application").val();
      aoData.push({
        name: "applicationName",
        value: applicationName
      });
      activityName = $("#filter_activity").val();
      aoData.push({
        name: "activityName",
        value: activityName
      });
      timeZone = $("#filter_time_zone").val();
      aoData.push({
        name: "timeZone",
        value: timeZone
      });
      startPeriod = $("#start_period").val();
      aoData.push({
        name: "startPeriod",
        value: startPeriod
      });
      endPeriod = $("#end_period").val();
      aoData.push({
        name: "endPeriod",
        value: endPeriod
      });
    }
  });
  $("#filter_application").on("change", function() {
    table.fnDraw();
  });
  $("#filter_activity").on("change", function() {
    table.fnDraw();
  });
  $("#filter_time_zone").on("change", function() {
    table.fnDraw();
  });
  $("#start_period").on("change", function() {
    table.fnDraw();
  });
  return $("#end_period").on("change", function() {
    table.fnDraw();
  });
});
