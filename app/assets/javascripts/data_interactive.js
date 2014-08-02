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

$(document).ready(function() {
var string_filter_instance = function() {
    var self = this;
    self.key = ko.observable('key1');
    self.list = ko.observable('value1');
    self.remove = ko.observable(false);
    self.filter_type = 'string';
}

var time_filter_instance = function() {
    var self = this;
    self.key = ko.observable('key1');
    self.start_time = ko.observable();
    self.end_time = ko.observable();
    self.filter_type = 'time';
}

function QueryViewModel() {
    //Data
    var self = this;
    this.filter = ko.observableArray([new string_filter_instance]);
    this.filter_having_keys = ko.observable({key: ko.observable('keyyy')});
    this.group = ko.observable('sdfgvhbn');

    this.availableGroups = ko.observableArray(['username','session','event','application','activity']);

    self.removeFilterInstance = function(filter_instance) {
        self.filter.remove(filter_instance);
    }

    self.addStringFilterInstanceToFilter = function() {
        self.filter.push(new string_filter_instance);
    }

    self.addTimeFilterInstanceToFilter = function() {
        self.filter.push(new time_filter_instance);
    }
}

ko.applyBindings(new QueryViewModel());
});