require 'json'
module Api

  class MeasuresController < ApplicationController
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
      @groups = Hash.new
      logs.select(parent).group(parent).order(parent).each do |log|
        @groups[log[parent]] = {"parent_values" => []}
        @groups[log[parent]]["parent_values"] << log[parent]
      end
      if request_body["measures"] != nil
        measures = request_body["measures"]
        measures.each do |measure_name, measure_info|
          @column_names << measure_name
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