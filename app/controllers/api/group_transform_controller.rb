require 'json'
include ERB::Util
module Api

  class GroupTransformController < ApplicationController
    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      if json_escape(params["filter"]).present?
        filter = JSON.parse(json_escape(params["filter"]))
      end
      if json_escape(params["filter_having_keys"]).present?
        filter_having_keys = JSON.parse(json_escape(params["filter_having_keys"]))
      end
      group = params["group"]
      if json_escape(params["measures"]).present?
        measures = JSON.parse(json_escape(params["measures"]))
      end
      logs = Log.all
      if (filter != nil)
        logs = Log.filter(filter)
      end
      if (filter_having_keys != nil)
        logs = logs.filter_having_keys(filter_having_keys)
      end
      if group != nil && !group.empty?
        @groups = Hash.new
        parent = group
        logs.select(parent).group(parent).order(parent).each do |log|
          @groups[log[parent]] = Hash.new
          @groups[log[parent]]["parent_values"] = []
          @groups[log[parent]]["parent_values"] << log[parent]
        end
        # @parent_keys used to store keys (columns) for Parent Table
        @parent_keys = []
        @parent_keys << parent
        # @child_keys used to store keys (columns) for Child Table
        @child_keys = []
        @child_keys = Log.column_names - %w{id parameters extras}
        @child_keys = @child_keys - @parent_keys
        logs.each do |log|
          log.parameters.present? ? @child_keys << log.parameters.keys : @child_keys << []
          log.extras.present? ? @child_keys << log.extras.keys : @child_keys << []
        end
        @child_keys = @child_keys.flatten.uniq
        if (parent =="username" || parent == "activity" || parent == "application" || parent == "session")
          child_data_groups = logs.group_by { |t| t.send(parent.to_sym) }
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
    end
  end
end