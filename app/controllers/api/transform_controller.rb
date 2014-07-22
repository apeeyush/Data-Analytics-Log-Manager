require 'json'
include ERB::Util
module Api

  class TransformController < ApplicationController

    before_action :authenticate_user!
    require_dependency 'transform_data.rb'
    require_dependency 'add_measure.rb'

    def index

      filter = JSON.parse(json_escape(params["filter"])) if json_escape(params["filter"]).present?
      filter_having_keys = JSON.parse(json_escape(params["filter_having_keys"])) if json_escape(params["filter_having_keys"]).present?
      child_filter = JSON.parse(json_escape(params["child_filter"])) if json_escape(params["child_filter"]).present?
      group = params["group"]    
      synthetic_data = JSON.parse(json_escape(params["synthetic_data"])) if json_escape(params["synthetic_data"]).present?
      measures = JSON.parse(json_escape(params["measures"])) if json_escape(params["measures"]).present?

      logs = Log.all
      logs = Log.filter(filter) if (filter != nil)
      logs = logs.filter_having_keys(filter_having_keys) if (filter_having_keys != nil)
      if group != nil && %w{username activity application session event}.include?(group)
        @groups = Hash.new
        parent = group
        parents_list = []
        logs.select(parent).group(parent).order(parent).each do |log|
          @groups[log[parent]] = Hash.new
          @groups[log[parent]]["parent_values"] = []
          @groups[log[parent]]["parent_values"] << log[parent]
          @groups[log[parent]]["child_values"] = []
          parents_list << log[parent]
        end
        # @parent_keys used to store keys (columns) for Parent Table
        @parent_keys = []
        @parent_keys << parent
        # @child_keys used to store keys (columns) for Child Table
        if child_filter != nil
          child_data_groups = logs.filter(child_filter).group_by { |t| t.send(parent.to_sym) }
          @child_keys = logs.filter(child_filter).keys_list
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

        if synthetic_data != nil
          if synthetic_data["rule"] != nil && synthetic_data["rule"]["pattern"] != nil
            pattern = synthetic_data["rule"]["pattern"]
          end
          if synthetic_data["result"] != nil
            result = synthetic_data["result"]
          end
          parents_list.each do |parent_name|
            child_logs = logs.where(parent => parent_name).order(:time)
            n = child_logs.count()
            m = pattern.length
            for i in 0..(n-m)
              j=0
              while j<m && logs[i+j].satisfies_conditions(pattern[j]) do
                j = j+1
              end
              if j==m
                index = result["clone"].to_i
                dup_log = logs[i+index].dup
                result["update_log"].each do |key, value|
                  dup_log.update_value(key, value)
                end
                child = []
                @child_keys.each do |child_key|
                  child << dup_log.value(child_key)
                end
                @groups[parent_name]["child_values"] << child
              end
            end
          end
        end
      end

      if measures.present? && !measures.empty?
        measures.each do |measure_name, measure_info|
          @parent_keys << measure_name
          # Aggregation measure : Filters and then does count(*)
          if measure_info.keys[0] == "Count"
            measures_hash = AddMeasure.calculate_count(measure_info["Count"], logs, parent, parents_list)
          # Measure to add key's value to parent table
          elsif measure_info.keys[0] == "AddValue"
            measures_hash = AddMeasure.calculate_values(measure_info["AddValue"], logs, parent, parents_list)
          # Measure to add sum of values for the specified key
          elsif measure_info.keys[0] == "Sum"
            measures_hash = AddMeasure.calculate_sum(measure_info["Sum"], logs, parent, parents_list)
          end
          @groups.each do |parent_name, value|
            value["parent_values"] << measures_hash[parent_name]
          end
        end
      end
      render "layouts/grouped_data.json.jbuilder"
  	end
  end
end