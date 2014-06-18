require 'json'
include ERB::Util
module Api

  class TableTransformController < ApplicationController
    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      if json_escape(params["filter"]).present?
        filter = JSON.parse(json_escape(params["filter"]))
      end
      if json_escape(params["filter_having_keys"]).present?
        filter_having_keys = JSON.parse(json_escape(params["filter_having_keys"]))
      end
      logs = Log.all
      if (filter != nil)
        logs = Log.filter(filter)
      end
      if (filter_having_keys != nil)
        logs = logs.filter_having_keys(filter_having_keys)
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
      else
        render status: :no_content
      end
    end

  end
end