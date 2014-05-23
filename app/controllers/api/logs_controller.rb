module Api

  class LogsController < ApplicationController

  	def index
  	  logs = Log.all
  	  render json: logs, status: 200
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
  	  log[:extras] = params[:extras]

  	  if log.save
  	  	render json: log, status: :created
  	  else
  	  	render json: log.errors, status: 422
  	  end
  	end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:session, :user, :application, :activity, :event, :time)
    end
end

end