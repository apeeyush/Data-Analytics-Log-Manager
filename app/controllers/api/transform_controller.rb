require 'json'
include ERB::Util
module Api

  class TransformController < ApplicationController
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
      if group != nil
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
      if measures != nil
        measures.each do |measure_name, measure_info|
          @parent_keys << measure_name
          if measure_info.keys[0] == "CountOfEvents"
            logs.select("#{parent}, count(event) as #{measure_name}").group(parent).order(parent).each do |values|
              @groups[values[parent]]["parent_values"] << values[measure_name]
            end
          elsif measure_info.keys[0] == "Count"
            if measure_info["Count"]["filter_having_keys"].present?
              logs = logs.filter_having_keys(measure_info["Count"]["filter_having_keys"])
            end
            if measure_info["Count"]["filter"].present?
              logs = logs.filter(measure_info["Count"]["filter"])
            end
            logs.select("#{parent}, count(*) as #{measure_name}").group(parent).order(parent).each do |values|
              @groups[values[parent]]["parent_values"] << values[measure_name]
            end
          end
        end
      end
  	end
  end
end