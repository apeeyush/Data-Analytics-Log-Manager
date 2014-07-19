require 'json'
module Api

  class SyntheticDataController < ApplicationController

    before_action :authenticate_user!

    def index
      request_body = JSON.parse(request.body.read)
      if request_body["group"] != nil
        @groups = Hash.new
        logs=Log.all
        parent = request_body["group"]
        pattern = request_body["synthetic_data"]["rule"]["pattern"]
        result = request_body["synthetic_data"]["result"]
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
      render "layouts/grouped_data.json.jbuilder"
    end
  end
end
