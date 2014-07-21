class LogsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show]

  # GET /logs
  # GET /logs.json
  def index
    application_list = current_user.applications.pluck(:name)
    logs = Log.where(application: application_list)
    @application_list = logs.uniq.pluck(:application)
    @activity_list = logs.uniq.pluck(:activity)
    respond_to do |format|
      format.html
      format.json { render json: LogsDatatable.new(view_context, application_list) }
    end
  end

end
