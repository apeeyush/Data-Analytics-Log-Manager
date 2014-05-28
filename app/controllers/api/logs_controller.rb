module Api

  class LogsController < ApplicationController

    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

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

  	def index
  	  @logs = Log.all
  	end

    def options
      render :text => '', :content_type => 'text/plain'
    end

  	def create
  	  log = Log.new()
  	  log[:session] = params[:session]
  	  log[:user] = params[:user]
  	  log[:application] = params[:application]
  	  log[:activity] = params[:activity]
  	  log[:event] = params[:event]
  	  log[:time] = DateTime.strptime("#{params[:time].to_i/1000}",'%s').in_time_zone("Eastern Time (US & Canada)").to_s
  	  log[:parameters] = params[:parameters]
  	  log[:extras] = Hash.new
      request.request_parameters.each do |key,value|
        if key != "log" && key != "session" && key != "user" && key != "application" && key != "activity" && key != "event" && key != "time" && key != "parameters"
          log[:extras][key] = value
        end
      end

  	  if log.save
  	  	render json: log, status: :created
  	  else
  	  	render json: log.errors, status: 422
  	  end
  	end

  end

end