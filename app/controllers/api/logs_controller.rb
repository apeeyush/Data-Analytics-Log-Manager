module Api
  require 'json'

  class LogsController < ApplicationController

    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    # Send empty text for options request
    def options
      render :text => '', :content_type => 'text/plain'
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
        new_log[:session] = log_data["session"]
        new_log[:username] = log_data["username"]
        new_log[:application] = log_data["application"]
        new_log[:activity] = log_data["activity"]
        new_log[:event] = log_data["event"]
        new_log[:time] = DateTime.strptime("#{log_data["time"].to_i/1000}",'%s').in_time_zone("Eastern Time (US & Canada)").to_s
        new_log[:parameters] = log_data["parameters"]
        new_log[:extras] = Hash.new
        log_data.each do |key, value|
          if key != "session" && key != "username" && key != "application" && key != "activity" && key != "event" && key != "time" && key != "parameters"
            new_log[:extras][key] = value
          end
        end
        if new_log.save
          return true, new_log
        else
          return false, new_log
        end
      end

  end
end