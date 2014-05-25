module Api

  class LogsController < ApplicationController

  	def index
  	  @logs = Log.all
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