require 'json'
include ERB::Util

class GroupTransformController < ApplicationController

  before_action :authenticate_user!
  require_dependency 'transform_data.rb'
  require_dependency 'add_measure.rb'
  require_dependency 'add_synthetic_data'

  def index
    query = JSON.parse(json_escape(params["json-textarea"]))

    # Apply filters on logs
    logs = Log.access_filter(current_user)
    logger.debug(query["filter"])
    logs = logs.filter(query["filter"]) if (query["filter"] != nil)
    logs = logs.filter_having_keys(query["filter_having_keys"]) if (query["filter_having_keys"].present? && query["filter_having_keys"]["keys_list"].present?)

    if query["group"] != nil && %w{username activity application session event}.include?(query["group"])
      @groups = Hash.new
      parent = query["group"]
      parents_list = []

      # Initialises @groups
      # @groups hash:
      #   "parent_name" =>
      #     "parent_values" => [List of parent table values]
      #     "child_values" => [[List of child table values],[],[],[]....]
      logs.select(parent).group(parent).order(parent).each do |log|
        @groups[log[parent]] = Hash.new
        @groups[log[parent]]["parent_values"] = []
        @groups[log[parent]]["parent_values"] << log[parent]
        @groups[log[parent]]["child_values"] = []
        parents_list << log[parent]
      end
      # @parent_keys used to store keys (column names) for Parent Table
      @parent_keys = []
      @parent_keys << parent
      
      if query["child_query"] != nil
        if query["child_query"]["add_child_data"] == true
          # @child_keys used to store keys (column names) for Child Table
          if !query["child_query"]["filter"].empty?
            child_data_groups = logs.filter(query["child_query"]["filter"]).group_by { |t| t.send(parent.to_sym) }
            @child_keys = logs.filter(query["child_query"]["filter"]).keys_list
          else
            child_data_groups = logs.group_by { |t| t.send(parent.to_sym) }
            @child_keys = logs.keys_list
          end
          # Keys that appear in parent table should not appear in child table
          @child_keys = @child_keys - @parent_keys
          # Enter child data in @groups
          child_data_groups.each do |parent_name, logs|
            child_array_collection = TransformData.transform_child_data(logs, parent_name, @child_keys)
            @groups[parent_name]["child_values"] = child_array_collection
          end
        end
      end

      if query["synthetic_data"] != nil
        synthetic_data = query["synthetic_data"]
        computed_logs = AddSyntheticData.compute(logs, parent, synthetic_data, parents_list, @child_keys)
        computed_logs.each do |computed_log|
          parent_name = computed_log[parent]
          child = []
          @child_keys.each do |child_key|
            child << computed_log.value(child_key)
          end
          @groups[parent_name]["child_values"] << child
        end
      end
    end

    if query["measures"].present? && !query["measures"].empty?
      query["measures"].each do |measure|
        @parent_keys << measure["name"]
        # Aggregation measure : Filters and then does count(*)
        if measure["measure_type"] == "count"
          measures_hash = AddMeasure.calculate_count(measure, logs, parent, parents_list)
        # Measure to add key's value to parent table
        elsif measure["measure_type"] == "value"
          measures_hash = AddMeasure.calculate_values(measure, logs, parent, parents_list)
        # Measure to add sum of values for the specified key
        elsif measure["measure_type"] == "sum"
          measures_hash = AddMeasure.calculate_sum(measure, logs, parent, parents_list)
        end
        @groups.each do |parent_name, value|
          value["parent_values"] << measures_hash[parent_name]
        end
      end
    end
    render "layouts/grouped_data.json.jbuilder"
  end
end