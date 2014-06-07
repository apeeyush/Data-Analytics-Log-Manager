module Api
  require 'json'

  class FilterController < ApplicationController
  	after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      request_body = JSON.parse(request.body.read)
      logs = Log.all
      string_columns = Log.column_names - %w{id parameters extras time}
      time_columns = []
      hstore_columns = %w{parameters extras}
      if (request_body["filter"] != nil)
        filter = request_body["filter"]
        string_columns.each do |string_column|
          if (filter[string_column] != nil && !filter[string_column].empty? )
            logs = logs.where({ string_column => filter[string_column]})
          end
        end
        if (filter["time"] != nil && !filter["time"].empty?)
        	logs = logs.where("time >= :start_time AND time <= :end_time",{start_time: filter["time"][0], end_time: filter["time"][1]})
        end
        hstore_columns.each do |hstore_column|
          if (filter[hstore_column] != nil && filter[hstore_column]["keys"] != nil && !filter[hstore_column]["keys"].empty?)
            keys = filter[hstore_column]["keys"]
            keys.each do |key|
              logs = logs.where("#{hstore_column} ? :key", key: key)
            end
          end
          if (filter[hstore_column] != nil && filter[hstore_column]["pairs"] != nil && !filter[hstore_column]["pairs"].empty?)
            pairs = filter[hstore_column]["pairs"]
            pairs.each do |pair|
              key = pair.keys[0]
              value = pair[key]
              logs = logs.where("extras @> (:key => :value)", :key => key, :value => value)
            end            
          end
        end
      end
	  if logs != nil
      	@logs = logs
        @column_names = []
        @column_names = Log.column_names - %w{id parameters extras}
        @logs.each do |log|
          log.parameters.present? ? @column_names << log.parameters.keys : @column_names << []
          log.extras.present? ? @column_names << log.extras.keys : @column_names << []
        end
        @column_names = @column_names.flatten.uniq
      else
        render status: :no_content
      end
    end

  end
end