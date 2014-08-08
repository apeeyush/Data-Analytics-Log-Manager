$(function() {

  $("#js-submit-query").click(function(){
    var btn = $(this);
    btn.button('loading');
    var query = $("#json-textarea").val();
    console.log($('#transformation_form').serialize());
    var parsed_query = JSON.parse(query);
    if ( parsed_query.group.length === 0) {
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


  function enableTab(id) {
    var el = document.getElementById(id);
    if (el !== null) {
    el.onkeydown = function(e) {
        if (e.keyCode === 9) { // tab was pressed

            // get caret position/selection
            var val = this.value,
                start = this.selectionStart,
                end = this.selectionEnd;

            // set textarea value to: text before caret + tab + text after caret
            this.value = val.substring(0, start) + '\t' + val.substring(end);

            // put caret at right position again
            this.selectionStart = this.selectionEnd = start + 1;

            // prevent the focus lose
            return false;

        }
    };
    }
  }
  enableTab('json-textarea');

});

$(document).ready(function() {

var string_filter_instance = function() {
    var self = this;
    self.key = ko.observable('string_key');
    self.list = ko.observableArray([ko.observable('asdf')]);
    self.remove = ko.observable(false);
    self.filter_type = 'string';

    removeListInstance = function(list_instance){
      self.list.remove(list_instance);
    }

}

var time_filter_instance = function() {
    var self = this;
    self.key = ko.observable('time_key');
    self.start_time = ko.observable('start_time');
    self.end_time = ko.observable('end_time');
    self.filter_type = 'time';

}

var count_measure = function() {
    var self = this;
    self.name = ko.observable('count_measure');
    self.filter = ko.observableArray();
    self.measure_type = 'count';

    self.removeFilterInstanceFromMeasure = function(filter_instance) {
      console.log(filter_instance)
      self.filter.remove(filter_instance);
    }
}

var sum_measure = function() {
    var self = this;
    self.name = ko.observable('sum_measure');
    self.filter = ko.observableArray();
    self.key = ko.observable('key')
    self.measure_type = 'sum';

    self.removeFilterInstanceFromMeasure = function(filter_instance) {
      self.filter.remove(filter_instance);
    }
}

var value_measure = function() {
    var self = this;
    self.name = ko.observable('value_measure');
    self.filter = ko.observableArray();
    self.key = ko.observable('key')
    self.measure_type = 'value';

    self.removeFilterInstanceFromMeasure = function(filter_instance) {
      self.filter.remove(filter_instance);
    }

}


function QueryViewModel() {
    //Data
    var self = this;
    this.filter = ko.observableArray();
    this.filter_having_keys = ko.observable({keys_list: ko.observableArray()});
    this.group = ko.observable();
    this.measures = ko.observableArray();

    this.availableGroups = ko.observableArray(['','username','session','event','application','activity']);

    // Filter Operations
    self.addStringFilterInstanceToFilter = function() {
      self.filter.push(new string_filter_instance);
    }
    self.addTimeFilterInstanceToFilter = function() {
      self.filter.push(new time_filter_instance);
    }
    self.removeFilterInstance = function(filter_instance) {
      self.filter.remove(filter_instance);
    }
    self.addListItemToFilter = function(filter) {
      filter.list.push(ko.observable('asdf'));
    }
    self.deleteListItemFromFilter = function(filter){
      filter.list.pop();
    }

    // Filter Having Keys operations
    self.addKeyToFilterHavingKeys = function() {
      self.filter_having_keys().keys_list.push(new ko.observable(''));
    }
    self.deleteKeyFromFilterHavingKeys = function() {
      self.filter_having_keys().keys_list.pop();
    }

    // Measure add/delete functions
    self.addCountMeasure = function() {
      self.measures.push(new count_measure);
    }
    self.addSumMeasure = function() {
      self.measures.push(new sum_measure);
    }
    self.addValueMeasure = function() {
      self.measures.push(new value_measure);
    }
    self.removeMeasureInstance = function(measure_instance){
      self.measures.remove(measure_instance);
    }
    // Add Filter to Measure
    self.addStringFilterInstanceToMeasure = function(measure) {
      measure.filter.push(new string_filter_instance);
    }
    self.addTimeFilterInstanceToMeasure = function(measure) {
      measure.filter.push(new time_filter_instance);
    }

}

ko.applyBindings(new QueryViewModel());
});

