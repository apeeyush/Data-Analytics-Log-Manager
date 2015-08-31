class TableTransformController < ApplicationController

  before_action :authenticate_user!

  def index
    @logs = Log.execute_query(params["json-textarea"], current_user)
    if @logs != nil
      @column_names = @logs.keys_list
      render "layouts/single_table.json.jbuilder"
    else
      render status: :no_content
    end
  end

end
