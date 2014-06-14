require 'json'
module Api

  class TransformController < ApplicationController
    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      request_body = JSON.parse(request.body.read)
      logs = Log.all
      if (request_body["filter"] != nil)
        logs = logs.filter(request_body["filter"])
      end
      if (request_body["filter_having_keys"] != nil)
        logs = logs.filter_having_keys(request_body["filter_having_keys"])
      end
      if request_body["group"] != nil
        @groups = Hash.new
        parent = request_body["group"]
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
      if request_body["measures"] != nil
        measures = request_body["measures"]
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