require 'json'
require 'spreadsheet'

class LogSpreadsheetsController < ApplicationController

  before_action :authenticate_user!

  def status
    spreadsheet = LogSpreadsheet.find(params.require(:id))
    render json: {status: spreadsheet.status, status_msg: spreadsheet.status_msg}
  end

  def file
    spreadsheet = LogSpreadsheet.find(params.require(:id))
    if spreadsheet.status != LogSpreadsheet::STATUS_SUCCEED
      # Spreadsheet is not generated yet or generation failed.
      render nothing: true, status: 400
      return
    end
    send_data spreadsheet.file.force_encoding('binary'), filename: 'logs.xls'
  end
end
