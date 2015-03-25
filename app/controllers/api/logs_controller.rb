module Api
  require 'json'

  class LogsController < ApplicationController

    skip_before_action :verify_authenticity_token

    # For CORS preflight
    def render204
      head 204
    end

    # Receive Post request and store logs from request body
  	def create
      # If the request body contains a single log (request body is not an array)
      if ( !JSON.parse(request.body.read).is_a?(Array) )
        log_data = JSON.parse(request.body.read)
        status, log = create_new_log(log_data)
        if (status)
          render json: log, status: :created
        else
          render json: log.errors, status: :unprocessable_entity
        end
      # If the request body contains multiple logs (request body is an array)
      else
        logs = []
        # Loop through all logs. Each array element is considered a single log
        JSON.parse(request.body.read).each do |log_data|
          status, log = create_new_log(log_data)
          if (!status)
            render render json: log.errors, status: :unprocessable_entity
          else
            logs.push(log)
          end
        end
        render json: logs, status: :created
      end
  	end

    private
      # Creates a new log from the log_data and stores it in the database.
      # Return Value:
      #   If successful   : true , saved log details
      #   If unsuccessful : false, unsuccessful save attempt log details
      def create_new_log (log_data)
        new_log = Log.new()
        logs_columns = Log.column_lists
        string_columns = logs_columns["string_columns"]
        string_columns.each do |string_column|
          new_log[string_column] = log_data[string_column]
        end
        time_columns = logs_columns["time_columns"]
        time_columns.each do |time_column|
          new_log[time_column] = Time.at(log_data[time_column].to_f / 1000).getutc
        end
        if new_log["application"].to_s == ''
          new_log[:application] = "Unknown: " + request.referer.to_s
        end
        new_log[:parameters] = log_data["parameters"] || {}
        new_log[:extras] = log_data.reject do |key, value|
          key == "parameters" || string_columns.include?(key) || time_columns.include?(key)
        end
        if new_log.save
          return true, new_log
        else
          return false, new_log
        end
      end

  end
end