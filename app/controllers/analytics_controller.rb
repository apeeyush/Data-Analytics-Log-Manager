class AnalyticsController < ApplicationController

  before_action :authenticate_user!
  layout 'analytics'

  def index
  end

  def all
  end

  def filter
  end

  def group
  end

  def transformation
  end

  def measures
  end

end
