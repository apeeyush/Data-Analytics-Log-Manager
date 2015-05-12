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
      height = 200-margin.top-margin.bottom;
  var svg = d3.select("#dashboard").append("svg:svg")
    .attr("width", width+margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  // Initialize variables/functions used by d3
  var time = function(d) { return Date.parse(d.time) }
  var timeDiff = function(d) { var nd = new Date(); return (Date.parse(d['time'])-nd.getTime())/(1000.0*60) }
  var datumId = function(d) { return 'name'+d.id }
  var x = d3.scale.linear()
    .domain([-5,0])
    .range([0,width]);
  var y = d3.scale.linear()
   .domain([0,5])
   .range([height,0]);
  var selectedNodesList = [];
  // Draw axis
  var xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')
      .tickSize(1);
  svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
    .append("text")
      .attr("class", "label")
      .attr("x", width)
      .attr("y", -6)
      .style("text-anchor", "end")
      .text("Minutes");

  // Refresh the location of datapoints on graph
  var refreshGraph = function(logData) {
    var circles = svg.selectAll("circle").data(logData, datumId)
    circles.transition()
      .attr("cx", function(d) { console.log(timeDiff(d)); return x(timeDiff(d)) })
      .attr("cy", function(d) { return y(1.5) })

    circles.enter()
      .append("svg:circle")
      .attr("r", 5)
      .attr("cx", function(d) { return x(timeDiff(d)) })
      .attr("cy", function(d) { return y(1.5) })
      .attr('id', function(d){ return datumId(d); })
      .style("fill-opacity", .7)
      .style("stroke", "green")
      .style("fill", "#99FF66")
      .on("click", function(d){
        clearSelectedStrokes(selectedNodesList);
        d3.select("#name"+d.id).style("stroke","black");
        d3.select("#name"+d.id).style("fill", "green");
        $('#status').empty();
        $('#status').append('<p>'+JSON.stringify(d)+'</p>');
        selectedNodesList.push(d.id);
      });
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
        var logData = data['logs'].slice();
        refreshGraph(logData);
      }
    });
  }, 5000);
  return intervalId;
}

function clearSelectedStrokes(selectedNodesList){
  for (var i=0; i<selectedNodesList.length; i++){
    id = selectedNodesList[i];
    d3.select("#name"+id).style("stroke","green");
    d3.select("#name"+id).style("fill", "#99FF66");
  }
}