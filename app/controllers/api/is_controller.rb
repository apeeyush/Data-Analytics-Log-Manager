module Api
  require 'json'

  # This controller was added to use import some Inquiry Space Data to the Log Manager.
  # The data did not consist of key-value pairs in the form directly consumable by the API.
  # This may be deprecated in further versions and should not be used.
  class IsController < ApplicationController

    def index
      # If the request body contains a single log (request body is not an array)
      if ( !JSON.parse(request.body.read).is_a?(Array) )
        log_data = JSON.parse(request.body.read)
        status, log = create_new_is_log(log_data)
        if (status)
          render json:log, status: :created
        else
          render render json: log.errors,status: 422
        end
      # If the request body contains multiple logs (request body is an array)
      else
        logs = []
        JSON.parse(request.body.read).each do |log_data|
          status, log = create_new_is_log(log_data)
          if (!status)
            render render json: log.errors,status: 422
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
      def create_new_is_log (log_data)
        new_log = Log.new()
        new_log[:session] = log_data["sessionID"]
        new_log[:username] = log_data["uname"]
        new_log[:application] = "IS"
        new_log[:activity] = log_data["activity"]
        new_log[:time] = log_data["timestamp"]
        new_log[:event] = log_data["message"][/^([\w\s\d]*)/,1]
        new_log[:event_value] = log_data["message"][/^([\w\s\d]*)[:\.](.*)/,2]
        new_log[:parameters] = log_data["parameters"]
        new_log[:extras] = Hash.new
        log_data.each do |key, value|
          if key != "sessionID" && key != "uname" && key != "application" && key != "activity" && key != "event" && key != "timestamp" && key != "parameters"
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