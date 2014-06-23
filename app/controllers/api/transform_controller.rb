require 'json'
include ERB::Util
module Api

  class TransformController < ApplicationController
    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      filter = JSON.parse(json_escape(params["filter"])) if json_escape(params["filter"]).present?
      filter_having_keys = JSON.parse(json_escape(params["filter_having_keys"])) if json_escape(params["filter_having_keys"]).present?
      child_filter = JSON.parse(json_escape(params["child_filter"])) if json_escape(params["child_filter"]).present?
      group = params["group"]    
      measures = JSON.parse(json_escape(params["measures"])) if json_escape(params["measures"]).present?
      logs = Log.all
      logs = Log.filter(filter) if (filter != nil)
      logs = logs.filter_having_keys(filter_having_keys) if (filter_having_keys != nil)
      if group != nil && !group.empty? && (group =="username" || group == "activity" || group == "application" || group == "session")
        @groups = Hash.new
        parent = group
        logs.select(parent).group(parent).order(parent).each do |log|
          @groups[log[parent]] = Hash.new
          @groups[log[parent]]["parent_values"] = []
          @groups[log[parent]]["parent_values"] << log[parent]
        end
        # @parent_keys used to store keys (columns) for Parent Table
        # @child_keys used to store keys (columns) for Child Table
        @parent_keys = []
        @parent_keys << parent
        if child_filter != nil
          child_data_groups = logs.filter(child_filter).group_by { |t| t.send(parent.to_sym) }
          @child_keys = logs.filter(child_filter).keys_list
        else
          child_data_groups = logs.group_by { |t| t.send(parent.to_sym) }
          @child_keys = logs.keys_list
        end
        child_data_groups.each do |parent_name, logs|
          child_collection = []
          logs.each do |log|
            child = []
            @child_keys.each do |child_key|
              child << log.value(child_key)
            end
            child_collection << child
          end
          @groups[parent_name]["child_values"] = child_collection
        end
      end

      if measures.present? && !measures.empty?
        measures.each do |measure_name, measure_info|
          @parent_keys << measure_name
          # Dummy measure, just used for testing
          if measure_info.keys[0] == "CountOfEvents"
            logs.select("#{parent}, count(event) as #{measure_name}").group(parent).order(parent).each do |values|
              @groups[values[parent]]["parent_values"] << values[measure_name]
            end
          # Aggregation measure : Filters and then does count(*)
          elsif measure_info.keys[0] == "Count"
            logs = logs.filter_having_keys(measure_info["Count"]["filter_having_keys"]) if measure_info["Count"]["filter_having_keys"].present?
            logs = logs.filter(measure_info["Count"]["filter"]) if measure_info["Count"]["filter"].present?
            logs.select("#{parent}, count(*) as #{measure_name}").group(parent).order(parent).each do |values|
              @groups[values[parent]]["parent_values"] << values[measure_name]
            end
          # Measure to add key's value to parent table
          elsif measure_info.keys[0] == "AddValue"
            logs = logs.filter_having_keys(measure_info["AddValue"]["filter_having_keys"]) if measure_info["AddValue"]["filter_having_keys"].present?
            logs = logs.filter(measure_info["AddValue"]["filter"]) if measure_info["AddValue"]["filter"].present?
            @groups.each do |parent_name, value|
              log = logs.where("#{parent} = :parent_name", parent_name: parent_name).order(:id).first
              log != nil ? value["parent_values"] <<  log.value(measure_info["AddValue"]["key"]) : value["parent_values"] << ""
            end
          end
        end
      end
      render "layouts/grouped_data.json.jbuilder"
  	end
  end
end