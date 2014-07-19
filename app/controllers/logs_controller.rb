class LogsController < ApplicationController
  before_action :set_log, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index, :show]

  # GET /logs
  # GET /logs.json
  def index
    @application_list = Log.uniq.pluck(:application)
    @activity_list = Log.uniq.pluck(:activity)
    respond_to do |format|
      format.html
      format.json { render json: LogsDatatable.new(view_context) }
    end
  end

end
