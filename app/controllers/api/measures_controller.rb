require 'json'
module Api

  class MeasuresController < ApplicationController

    before_action :authenticate_user!
    require_dependency 'add_measure.rb'

  	def index
      @column_names = []
      @values = []
      request_body = JSON.parse(request.body.read)
      logs = Log.access_filter(current_user)
      if request_body["group"] != nil && %w{username activity application session event}.include?(request_body["group"])
      	parent = request_body["group"]
        @column_names << request_body["group"]
      end
      parents_list = []
      @groups = Hash.new
      logs.select(parent).group(parent).order(parent).each do |log|
        @groups[log[parent]] = {"parent_values" => []}
        @groups[log[parent]]["parent_values"] << log[parent]
        parents_list << log[parent]
      end
      if request_body["measures"] != nil
        measures = request_body["measures"]
        measures.each do |measure_name, measure_info|
          # Aggregation measure : Filters and then does count(*)
          if measure_info.keys[0] == "Count"
            measures_hash = AddMeasure.calculate_count(measure_info["Count"], logs, parent, parents_list)
          # Measure to add key's value to parent table
          elsif measure_info.keys[0] == "AddValue"
            measures_hash = AddMeasure.calculate_values(measure_info["AddValue"], logs, parent, parents_list)
          # Add Sum of values for specified key grouped by username
          elsif measure_info.keys[0] == "Sum"
            measures_hash = AddMeasure.calculate_sum(measure_info["Sum"], logs, parent, parents_list)
          end
          @column_names << measure_name
          @groups.each do |parent_name, value|
            value["parent_values"] << measures_hash[parent_name]
          end
        end
      end
  	end
  end
end