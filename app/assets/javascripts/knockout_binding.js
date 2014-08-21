// KnockoutJS Data Binding
$(document).ready(function() {

var string_filter_instance = function() {
    var self = this;
    self.key = ko.observable('');
    self.list = ko.observableArray([ko.observable('')]);
    self.remove = ko.observable(false);
    self.filter_type = 'string';

    removeListInstance = function(list_instance){
      self.list.remove(list_instance);
    };
};

var time_filter_instance = function() {
    var self = this;
    self.key = ko.observable('');
    self.start_time = ko.observable('');
    self.end_time = ko.observable('');
    self.filter_type = 'time';
};

var count_measure = function() {
    var self = this;
    self.name = ko.observable('count_measure');
    self.filter = ko.observableArray();
    self.measure_type = 'count';

    self.removeFilterInstanceFromMeasure = function(filter_instance) {
      self.filter.remove(filter_instance);
    };
};

var sum_measure = function() {
    var self = this;
    self.name = ko.observable('sum_measure');
    self.filter = ko.observableArray();
    self.key = ko.observable('key');
    self.measure_type = 'sum';

    self.removeFilterInstanceFromMeasure = function(filter_instance) {
      self.filter.remove(filter_instance);
    };
};

var value_measure = function() {
    var self = this;
    self.name = ko.observable('value_measure');
    self.filter = ko.observableArray();
    self.key = ko.observable('key');
    self.measure_type = 'value';

    self.removeFilterInstanceFromMeasure = function(filter_instance) {
      self.filter.remove(filter_instance);
    };
};

function QueryViewModel() {
    //Data
    var self = this;
    this.filter = ko.observableArray();
    this.filter_having_keys = ko.observable({
      keys_list: ko.observableArray()
    });
    this.group = ko.observable();
    this.measures = ko.observableArray();
    this.child_query = ko.observable({
      filter: ko.observableArray(),
      add_child_data: ko.observable(false)
    });

    this.recommendedGroups = ko.observableArray(['','username','session','event','application','activity']);

    // Filter Operations
    self.addStringFilterInstanceToFilter = function() {
      self.filter.push(new string_filter_instance);
    };
    self.addTimeFilterInstanceToFilter = function() {
      self.filter.push(new time_filter_instance);
    };
    self.removeFilterInstance = function(filter_instance) {
      self.filter.remove(filter_instance);
    };
    self.addListItemToFilter = function(filter) {
      filter.list.push(ko.observable(''));
    };
    self.deleteListItemFromFilter = function(filter, index){
      filter.list.remove(filter.list()[index]);
    };

    // Filter Having Keys operations
    self.addKeyToFilterHavingKeys = function() {
      self.filter_having_keys().keys_list.push(new ko.observable(''));
    };
    self.deleteKeyFromFilterHavingKeys = function(index) {
      self.filter_having_keys().keys_list.remove(self.filter_having_keys().keys_list()[index]);
    };

    // Measure add/delete functions
    self.addCountMeasure = function() {
      self.measures.push(new count_measure);
    };
    self.addSumMeasure = function() {
      self.measures.push(new sum_measure);
    };
    self.addValueMeasure = function() {
      self.measures.push(new value_measure);
    };
    self.removeMeasureInstance = function(measure_instance){
      self.measures.remove(measure_instance);
    };
    // Add Filter to Measure
    self.addStringFilterInstanceToMeasure = function(measure) {
      measure.filter.push(new string_filter_instance);
    };
    self.addTimeFilterInstanceToMeasure = function(measure) {
      measure.filter.push(new time_filter_instance);
    };

    self.removeFilterInstanceFromChildData = function(filter_as){
      self.child_query().filter.remove(filter_as)
    };
    self.addStringFilterInstanceToChildQuery = function() {
      self.child_query().filter.push(new string_filter_instance);
    };
    self.addTimeFilterInstanceToChildQuery = function() {
      self.child_query().filter.push(new time_filter_instance);
    };

}

ko.applyBindings(new QueryViewModel());
});
