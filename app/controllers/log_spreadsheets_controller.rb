require 'json'

class LogSpreadsheetsController < ApplicationController
  include ActionController::Live

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

    begin
      set_file_headers("logs-#{spreadsheet.id}.#{spreadsheet.format}")
      spreadsheet.for_file_chunks do |chunk|
        response.stream.write chunk
      end
    ensure
      response.stream.close
    end
  end

  private

  def set_file_headers(file_name)
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end

end
