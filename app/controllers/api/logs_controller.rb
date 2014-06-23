module Api
  require 'json'

  class LogsController < ApplicationController

    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

  	def index
  	  @logs = Log.all
      @column_names = []
      @column_names = Log.column_names - %w{id parameters extras}
      @logs.each do |log|
        log.parameters.present? ? @column_names << log.parameters.keys : @column_names << []
        log.extras.present? ? @column_names << log.extras.keys : @column_names << []
      end
      @column_names = @column_names.flatten.uniq
      render "layouts/single_table.json.jbuilder"
  	end

    # Send empty text for options request
    def options
      render :text => '', :content_type => 'text/plain'
    end

  	def create
      if ( !JSON.parse(request.body.read).is_a?(Array) )
        log_data = JSON.parse(request.body.read)
        status, log = create_new_log(log_data)
        if (status)
          render json:log, status: :created
        else
          render render json: log.errors,status: 422
        end
      else
        logs = []
        JSON.parse(request.body.read).each do |log_data|
          status, log = create_new_log(log_data)
          if (!status)
            render render json: log.errors,status: 422
          else
            logs.push(log)
          end
        end
        render json: logs, status: :created
      end
  	end

    private
      def create_new_log (log_data)
        new_log = Log.new()
        new_log[:session] = log_data["session"]
        new_log[:username] = log_data["username"]
        new_log[:application] = log_data["application"]
        new_log[:activity] = log_data["activity"]
        new_log[:event] = log_data["event"]
        new_log[:time] = DateTime.strptime("#{log_data["time"].to_i/1000}",'%s').in_time_zone("Eastern Time (US & Canada)").to_s
        new_log[:parameters] = log_data["parameters"]
        new_log[:extras] = Hash.new
        log_data.each do |key, value|
          if key != "session" && key != "username" && key != "application" && key != "activity" && key != "event" && key != "time" && key != "parameters"
            new_log[:extras][key] = value
          end
        end
        if new_log.save
          return true, new_log# render json: log, status: :created
        else
          return false, new_log # render json: log.errors, status: 422
        end
      end

  end
end