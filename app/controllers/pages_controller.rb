class PagesController < ApplicationController

  before_action :authenticate_user!, only: [:explore, :get_explore_data]

  def main
  end

  def explore
    @application_list = Log.access_filter(current_user).uniq.pluck(:application)
    @activity_list = Log.access_filter(current_user).uniq.pluck(:activity)
  end

  def get_explore_data
    application = params[:explore][:application]
    activity = params[:explore][:activity]
    logs = Log.access_filter(current_user)
    logs = logs.where(application: application) if application.present?
    logs = logs.where(activity: activity) if activity.present?
    @events = logs.uniq.pluck(:event)
    @keys = logs.keys_list
  end

end
