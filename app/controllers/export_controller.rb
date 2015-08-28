class ExportController < ApplicationController

  before_action :authenticate_user!

  # Enqueues log spreadsheet generation job and returns URLs that can be used to check its status
  # and download spreadsheet file once it's ready.
  def log_spreadsheet
    spreadsheet = LogSpreadsheet.create!(query: params['json-textarea'], user_id: current_user.id)
    Delayed::Job.enqueue SpreadsheetExportJob.new(spreadsheet.id)
    render json: {
             status_path: status_log_spreadsheet_path(spreadsheet),
             file_path: file_log_spreadsheet_path(spreadsheet)
           }
  end
end
