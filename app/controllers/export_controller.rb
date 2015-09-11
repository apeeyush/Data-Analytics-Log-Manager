class ExportController < ApplicationController

  before_action :authenticate_user!

  # Enqueues log spreadsheet generation job and returns URLs that can be used to check its status
  # and download spreadsheet file once it's ready.
  def log_spreadsheet
    spreadsheet = LogSpreadsheet.new(query: params['json-textarea'], user_id: current_user.id)
    if spreadsheet.too_big?
      render status: 400, json: {
               error: "Too many log entries (#{spreadsheet.logs_count} vs #{LogSpreadsheet::LOGS_COUNT_LIMIT} limit)"
             }
      return
    end
    spreadsheet.save!
    Delayed::Job.enqueue SpreadsheetExportJob.new(spreadsheet.id)
    render json: {
             status_path: status_log_spreadsheet_path(spreadsheet),
             file_path: file_log_spreadsheet_path(spreadsheet)
           }
  end
end
