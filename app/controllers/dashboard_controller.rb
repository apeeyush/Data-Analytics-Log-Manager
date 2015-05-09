class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
    @application_list = Log.access_filter(current_user).uniq.pluck(:application)
    @activity_list = Log.access_filter(current_user).uniq.pluck(:activity)
  end

  def get_monitoring_data
    application = params[:application]
    activity = params[:activity]
    logs = Log.access_filter(current_user)
    logs = logs.where(application: application) if application.present?
    logs = logs.where(activity: activity) if activity.present?
    if params[:startPeriod].present?
      startPeriod = Time.at(params[:startPeriod].to_i/1000.0)
      logs = logs.where("time >= :startPeriod", {startPeriod: startPeriod})
    end
	if params[:endPeriod].present?
      endPeriod = Time.at(params[:endPeriod].to_i/1000.0)
      logs = logs.where("time <= :endPeriod", {endPeriod: endPeriod})
	end
    @logs = logs
  end

end
