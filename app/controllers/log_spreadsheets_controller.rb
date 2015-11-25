require 'json'

class LogSpreadsheetsController < ApplicationController

  before_action :authenticate_user!

  def status
    # WARNING: note that 'file' field can be huge sometimes. Don't load it when it's not needed,
    #          limit fields to 'status' and 'status_msg' only.
    spreadsheet = LogSpreadsheet.select('status', 'status_msg').find(params.require(:id))
    render json: {status: spreadsheet.status, status_msg: spreadsheet.status_msg}
  end

  def file
    spreadsheet = LogSpreadsheet.find(params.require(:id))
    if spreadsheet.status != LogSpreadsheet::STATUS_SUCCEED
      # Spreadsheet is not generated yet or generation failed.
      render nothing: true, status: 400
      return
    end
    send_data spreadsheet.file, filename: "logs-#{spreadsheet.id}.csv", type: 'text/csv'
  end
end
