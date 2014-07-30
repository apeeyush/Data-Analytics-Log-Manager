require 'json'
include ERB::Util
module Api

  class SyntheticDataController < ApplicationController

    before_action :authenticate_user!
    require_dependency 'add_synthetic_data'

    def index
      request_body = JSON.parse(request.body.read)
      if request_body["group"] != nil
        @groups = Hash.new
        logs = Log.access_filter(current_user)
        parent = request_body["group"]
        synthetic_data = request_body["synthetic_data"]
        parents_list = []
        logs.select(parent).group(parent).order(parent).each do |log|
          @groups[log[parent]] = Hash.new
          @groups[log[parent]]["parent_values"] = []
          @groups[log[parent]]["child_values"] = []
          @groups[log[parent]]["parent_values"] << log[parent]
          parents_list << log[parent]
        end
        # @parent_keys used to store keys (columns) for Parent Table
        @parent_keys = []
        @parent_keys << parent
        # @child_keys used to store keys (columns) for Child Table
        @child_keys = logs.keys_list
        @child_keys = @child_keys - @parent_keys

        if synthetic_data != nil
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
      render "layouts/grouped_data.json.jbuilder"
    end
  end
end
