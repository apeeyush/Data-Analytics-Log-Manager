module Api
  require 'json'

  class FilterController < ApplicationController

    before_action :authenticate_user!

    def index
      request_body = JSON.parse(request.body.read)
      logs = Log.access_filter(current_user)
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