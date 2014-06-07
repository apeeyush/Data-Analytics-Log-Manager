require 'json'
module Api

  class TransformController < ApplicationController
    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

  	def index
      request_body = JSON.parse(request.body.read)
      logs_columns = Hash.new
      Log.columns.each do |column|
        logs_columns[column.name] = column.type
      end
      string_columns = []
      time_columns = []
      hstore_columns = []
      logs_columns.except!("id")
      logs_columns.each do |column_name, type|
        if type == :string
          string_columns << column_name
        elsif type == :datetime
          time_columns << column_name
        elsif type == :hstore
          hstore_columns << column_name
        end
      end
      logs = Log.all
      if (request_body["filter"] != nil)
        filter = request_body["filter"]
        string_columns.each do |string_column|
          if (filter[string_column] != nil && !filter[string_column].empty? )
            logs = logs.where({ string_column => filter[string_column]})
          end
        end
        time_columns.each do |time_column|
          if (filter[time_column] != nil && !filter[time_column].empty?)
           logs = logs.where("#{time_column} >= :start_time AND time <= :end_time",{start_time: filter["time"][0], end_time: filter["time"][1]})
          end
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
      if request_body["group"] != nil
      	@parent = request_body["group"]
        if (@parent =="username" || @parent == "activity" || @parent == "application" || @parent == "session")
          @groups = logs.group_by { |t| t.send(@parent.to_sym) }
        else
          # Group by Username by default
          @groups = logs.group_by { |t| t.username }
        end
        # @parent_keys used to store keys (columns) for Parent Table
        @parent_keys = []
        @parent_keys << @parent
        # @child_keys used to store keys (columns) for Child Table
        @child_keys = []
        @child_keys = Log.column_names - %w{id parameters extras}
        @child_keys = @child_keys - @parent_keys
        @groups.each do |parent_name, logs|
          logs.each do |log|
            log.parameters.present? ? @child_keys << log.parameters.keys : @child_keys << []
            log.extras.present? ? @child_keys << log.extras.keys : @child_keys << []
          end
          @child_keys = @child_keys.flatten.uniq
        end
      end
  	end
  end
end