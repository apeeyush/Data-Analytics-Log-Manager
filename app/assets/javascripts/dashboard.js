jQuery(function() {
  var intervalId = null;
  $(".js-start-monitoring").click(function(){
    $('.js-stop-monitoring').prop('disabled', false);
    $(".js-start-monitoring").prop('disabled', true);
    $("#dashboard").empty();
    var application = JSON.parse(JSON.stringify($('#monitor').serializeArray()))[2].value
    var activity = JSON.parse(JSON.stringify($('#monitor').serializeArray()))[3].value
    console.log(application);
    console.log(activity);
    intervalId = monitor();
  });

  $(".js-stop-monitoring").click(function(){
    $('.js-stop-monitoring').prop('disabled', true);
    $(".js-start-monitoring").prop('disabled', false);
    clearInterval(intervalId);
    refreshIntervalIds = null;
  });

});

function monitor(){
  // Collect parameters for HTML form fields
  var application = $('#monitor').find("select[name='monitor[application]']").val();
  var activity = $('#monitor').find("select[name='monitor[activity]']").val();
  // Initialize graph
  var margin = {top: 20, right: 20, bottom: 40, left:40},
      width = 1000-margin.left-margin.right,
      height = 100-margin.top-margin.bottom;
  var svg = d3.select("#dashboard").append("svg:svg")
    .attr("width", width+margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  // Initialize variables/functions used by d3
  var time = function(d) { return Date.parse(d.time) }
  var timeDiff = function(d) { var nd = new Date(); return (Date.parse(d['time'])-nd.getTime())/(1000.0*60) }
  var datumId = function(d) { return d.id }
  var x = d3.scale.linear()
    .domain([-5,0])
    .range([0,width]);
  var y = d3.scale.linear()
   .domain([5,0])
   .range([height,0]);
  // Draw axis
  var xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')
      .tickSize(1);
  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
  // Refresh the location of datapoints on graph
  var refreshGraph = function(logData) {
    var circles = svg.selectAll("circle").data(logData, datumId)
    circles.transition()
      .attr("cx", function(d) { console.log(timeDiff(d)); return x(timeDiff(d)) })
      .attr("cy", function(d) { return y(1.5) })

    circles.enter()
      .append("svg:circle")
      .attr("r", 3)
      .attr("cx", function(d) { return x(timeDiff(d)) })
      .attr("cy", function(d) { return y(1.5) })
      .style("fill-opacity", .7)
      .style("stroke", "green")
      .style("fill", "green");

    circles.exit()
     .remove()
  }
  // Start a loop that updates datapoints every 5 seconds
  var data = {application:application, activity: activity};
  var intervalId = setInterval(function(){
    var d = new Date();
    var utcTimestamp = d.getTime();
    data['startPeriod'] = utcTimestamp-5*60*1000;
    data['endPeriod'] = utcTimestamp;
    $.ajax({
      type: "POST",
      url: "/dashboard/get_monitoring_data",
      data: data,
      success: function(data) {
        showLogs(data['logs']);
        var logData = data['logs'].slice();
        refreshGraph(logData);
      }
    });
  }, 5000);
  return intervalId;
}

function showLogs(data){
  $("#logs-list").empty();
  var eventsLength = data.length;
  for (var i = 0; i < eventsLength; i++) {
    $("#logs-list").append('<li style="font-size:10px";>' + JSON.stringify(data[i]) + '</li>');
  }
}
