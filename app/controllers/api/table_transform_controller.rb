require 'json'
include ERB::Util
module Api

  class TableTransformController < ApplicationController

    before_action :authenticate_user!

    def index
      filter = JSON.parse(json_escape(params["filter"])) if json_escape(params["filter"]).present?
      filter_having_keys = JSON.parse(json_escape(params["filter_having_keys"])) if json_escape(params["filter_having_keys"]).present?

      logs = Log.access_filter(current_user)
      logs = logs.filter(filter) if (filter != nil)
      logs = logs.filter_having_keys(filter_having_keys) if (filter_having_keys != nil)

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