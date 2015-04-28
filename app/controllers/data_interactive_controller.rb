class DataInteractiveController < ApplicationController

  before_action :authenticate_user!

  def index
    unless params[:rep].nil? or params[:ids].nil?
      prefix = params[:rep]
      run_remote_endpoints = params[:ids].split('-').map { |id| prefix + id }

      @prepopulated_data ||= {}
      @prepopulated_data[:stringFilters] ||= []
      @prepopulated_data[:stringFilters].push :key => "run_remote_endpoint", :values => run_remote_endpoints
    end
  end
end
