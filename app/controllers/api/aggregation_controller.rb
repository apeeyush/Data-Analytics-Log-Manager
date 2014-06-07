require 'json'
module Api

  class AggregationController < ApplicationController
    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

  	def index
      @column_names = []
      @values = []
      request_body = JSON.parse(request.body.read)
      logs = Log.all
      if request_body["group"] != nil
      	parent = request_body["group"]
        @column_names << request_body["group"]
      end
      @parent_values_list = []
      @groups = Hash.new
      Log.select(parent).group(parent).order(parent).each do |log|
        @parent_values_list << log[parent]
        @groups[log[parent]] = {"parent_values" => []}
        @groups[log[parent]]["parent_values"] << log[parent]
      end
      if request_body["aggregations"] != nil
        aggregations = request_body["aggregations"]
        aggregations.each do |aggregation_name, aggregation_info|
          @column_names << aggregation_name
          if (aggregation_info.keys[0] == "CountOfEvents")
            Log.select("#{parent}, count(event) as #{aggregation_name}").group(parent).order(parent).each do |values|
              @groups[values[parent]]["parent_values"] << values[aggregation_name]
            end
          end
        end
      end
      logger.debug(@groups)
  	end
  end
end