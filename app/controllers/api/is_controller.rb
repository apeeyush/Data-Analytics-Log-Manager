module Api
  require 'json'

  class IsController < ApplicationController

    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      if ( !JSON.parse(request.body.read).is_a?(Array) )
        log_data = JSON.parse(request.body.read)
        status, log = create_new_is_log(log_data)
        if (status)
          render json:log, status: :created
        else
          render render json: log.errors,status: 422
        end
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
          return true, new_log# render json: log, status: :created
        else
          return false, new_log # render json: log.errors, status: 422
        end
      end

  end
end