module Api
  require 'json'

  class FilterController < ApplicationController
  	after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      request_body = JSON.parse(request.body.read)
      logs = Log.all
      logs = logs.filter(request_body["filter"]) if (request_body["filter"] != nil)
      logs = logs.filter_having_keys(request_body["filter_having_keys"]) if (request_body["filter_having_keys"] != nil)
      if logs != nil
        @logs = logs
        @column_names = logs.keys_list
        render "layouts/single_table.json.jbuilder"
      else
        render status: :no_content
      end
    end

  end
end