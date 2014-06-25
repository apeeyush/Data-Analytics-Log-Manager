class PagesController < ApplicationController
  def main
  end

  def explore
    @application_list = Log.uniq.pluck(:application)
    @activity_list = Log.uniq.pluck(:activity)
  end

  def get_explore_data
    application = params[:explore][:application]
    activity = params[:explore][:activity]
    logs = Log.all
    logs = logs.where(application: application) if application.present?
    logs = logs.where(activity: activity) if activity.present?
    @events = logs.uniq.pluck(:event)
    @keys = logs.keys_list
  end

end
