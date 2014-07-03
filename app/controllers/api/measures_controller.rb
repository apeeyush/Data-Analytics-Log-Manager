require 'json'
module Api

  class MeasuresController < ApplicationController

    before_action :authenticate_user!

  	def index
      @column_names = []
      @values = []
      request_body = JSON.parse(request.body.read)
      logs = Log.all
      if request_body["group"] != nil && %w{username activity application session event}.include?(request_body["group"])
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