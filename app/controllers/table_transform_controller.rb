class TableTransformController < ApplicationController

  before_action :authenticate_user!

  def index
    @logs = Log.execute_query(params["json-textarea"], current_user)
    if @logs != nil
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
