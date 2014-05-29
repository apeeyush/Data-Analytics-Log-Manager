module Api
  require 'json'

  class LogsController < ApplicationController

    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

  	def index
  	  @logs = Log.all
  	end

    # Send empty text for options request
    def options
      render :text => '', :content_type => 'text/plain'
    end

  	def create
      if ( !JSON.parse(request.body.read).is_a?(Array) )
        log_data = JSON.parse(request.body.read)
        status, log = create_new_log(log_data)
        if (status)
          render json:log, status: :created
        else
          render render json: log.errors,status: 422
        end
      else
        logs = []
        JSON.parse(request.body.read).each do |log_data|
          status, log = create_new_log(log_data)
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
      def create_new_log (log_data)
        new_log = Log.new()
        new_log[:session] = log_data["session"]
        new_log[:user] = log_data["user"]
        new_log[:application] = log_data["application"]
        new_log[:activity] = log_data["activity"]
        new_log[:event] = log_data["event"]
        new_log[:time] = DateTime.strptime("#{log_data["time"].to_i/1000}",'%s').in_time_zone("Eastern Time (US & Canada)").to_s
        new_log[:parameters] = log_data["parameters"]
        new_log[:extras] = Hash.new
        log_data.each do |key, value|
          if key != "session" && key != "user" && key != "application" && key != "activity" && key != "event" && key != "time" && key != "parameters"
            new_log[:extras][key] = value
          end
        end
        if new_log.save
          return true, new_log# render json: log, status: :created
        else
          return false, new_log # render json: log.errors, status: 422
        end
      end

      # For all responses in this controller, return the CORS access control headers.
      def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
        headers['Access-Control-Max-Age'] = "1728000"
      end

      # If this is a preflight OPTIONS request, then short-circuit the
      # request, return only the necessary headers and return an empty
      # text/plain.
      def cors_preflight_check
        if request.request_method == "OPTIONS"
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
          headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept'
          headers['Access-Control-Max-Age'] = '1728000'
        end
      end
  end
end