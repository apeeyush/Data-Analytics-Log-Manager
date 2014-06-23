module Api
  require 'json'

  class FilterController < ApplicationController
  	after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      request_body = JSON.parse(request.body.read)
      logs = Log.all
      if (request_body["filter"] != nil)
        logs = logs.filter(request_body["filter"])
      end
      if (request_body["filter_having_keys"] != nil)
        logs = logs.filter_having_keys(request_body["filter_having_keys"])
      end
	    if logs != nil
      	@logs = logs
        @column_names = []
        @column_names = Log.column_names - %w{id parameters extras}
        @logs.each do |log|
          log.parameters.present? ? @column_names << log.parameters.keys : @column_names << []
          log.extras.present? ? @column_names << log.extras.keys : @column_names << []
        end
        @column_names = @column_names.flatten.uniq
        render "layouts/single_table.json.jbuilder"
      else
        render status: :no_content
      end
    end

  end
end