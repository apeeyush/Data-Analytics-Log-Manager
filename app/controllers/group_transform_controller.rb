require 'json'
include ERB::Util

class GroupTransformController < ApplicationController

  before_action :authenticate_user!
  before_action :initialize_transform
  require_dependency 'transform_data.rb'
  require_dependency 'add_measure.rb'
  require_dependency 'add_synthetic_data'

  def index
    if @query["group"] != nil && %w{username activity application session event}.include?(@query["group"])
      initialize_group_transform
      if @query["child_query"].present?
        if @query["child_query"]["add_child_data"] == true
          add_child_data_to_groups
        end
      end
      if @query["synthetic_data"].present?
        add_synthetic_data_to_groups
      end
      if @query["measures"].present?
        add_measures_data_to_groups
      end
    end
    render "layouts/grouped_data.json.jbuilder"
  end

  # Used to initialize the transformation process
  # Extracts query from request params and applies initial filters on Log
  def initialize_transform
    @query = JSON.parse(json_escape(params["json-textarea"]))
    # Apply filters on logs
    @logs = Log.access_filter(current_user)
    @logs = @logs.filter(@query["filter"]) if (@query["filter"].present?)
    @logs = @logs.filter_having_keys(@query["filter_having_keys"]) if (@query["filter_having_keys"].present? && @query["filter_having_keys"]["keys_list"].present?)
  end

  # Initialises the variables required for Group Transform
  # Variables Initialized : @groups, @parents_list, @parent_table_keys, @parent_column
  #
  # @groups
  #   It is a hash with the following format:
  #     "parent_name" =>
  #       "parent_values" => [List of parent table values]
  #       "child_values" => [[List of child table values],[],[],[]....]
  #
  # @parents_list:
  #   Stores a list of parents
  #
  # @parent_table_keys:
  #   Stores keys (column_names) for Parent Table
  #
  # @parent_column
  #   Contains the name of parent column i.e. the column using which, the data will be grouped
  def initialize_group_transform
    @parents_list = []
    @groups = Hash.new
    @parent_column = @query["group"]
    @logs.select(@parent_column).group(@parent_column).order(@parent_column).each do |log|
      @groups[log[@parent_column]] = Hash.new
      @groups[log[@parent_column]]["parent_values"] = []
      @groups[log[@parent_column]]["parent_values"] << log[@parent_column]
      @groups[log[@parent_column]]["child_values"] = []
      @parents_list << log[@parent_column]
    end
    @parent_table_keys = []
    @parent_table_keys << @parent_column
  end

  # Loads child data in @groups after applying child query filters
  def add_child_data_to_groups
    # @child_table_keys used to store keys (column names) for Child Table
    if !@query["child_query"]["filter"].empty?
      child_data_groups = @logs.filter(@query["child_query"]["filter"]).group_by { |t| t.send(@parent_column.to_sym) }
      @child_table_keys = @logs.filter(@query["child_query"]["filter"]).keys_list
    else
      child_data_groups = @logs.group_by { |t| t.send(@parent_column.to_sym) }
      @child_table_keys = @logs.keys_list
    end
    # Keys that appear in parent table should not appear in child table
    @child_table_keys = @child_table_keys - @parent_table_keys
    # Enter child data in @groups
    child_data_groups.each do |parent_name, logs|
      child_array_collection = TransformData.transform_child_data(logs, parent_name, @child_table_keys)
      @groups[parent_name]["child_values"] = child_array_collection
    end
  end

  # Based on query synthetic_data value, it calculates the required synthetic_data and stores it in @groups
  def add_synthetic_data_to_groups
    synthetic_data = @query["synthetic_data"]
    computed_logs = AddSyntheticData.compute(@logs, @parent_column, synthetic_data, @parents_list, @child_table_keys)
    computed_logs.each do |computed_log|
      parent_name = computed_log[@parent_column]
      child = []
      @child_table_keys.each do |child_key|
        child << computed_log.value(child_key)
      end
      @groups[parent_name]["child_values"] << child
    end
  end

  # Based on query measures value, it calculates the required values and stores it in @groups
  def add_measures_data_to_groups
    @query["measures"].each do |measure|
      @parent_table_keys << measure["name"]
      # Aggregation measure : Filters and then does count(*)
      if measure["measure_type"] == "count"
        measures_hash = AddMeasure.calculate_count(measure, @logs, @parent_column, @parents_list)
      # Measure to add key's value to parent table
      elsif measure["measure_type"] == "value"
        measures_hash = AddMeasure.calculate_values(measure, @logs, @parent_column, @parents_list)
      # Measure to add sum of values for the specified key
      elsif measure["measure_type"] == "sum"
        measures_hash = AddMeasure.calculate_sum(measure, @logs, @parent_column, @parents_list)
      end
      @groups.each do |parent_name, value|
        value["parent_values"] << measures_hash[parent_name]
      end
    end
  end

end