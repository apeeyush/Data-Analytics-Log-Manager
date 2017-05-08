class SpreadsheetExportJob < Struct.new(:log_spreadsheet_id)
  def enqueue(job)
    update_status(LogSpreadsheet::STATUS_ENQUEUED, 'Waiting in queue...')

    job.delayed_reference_id   = log_spreadsheet_id
    job.delayed_reference_type = 'LogSpreadsheet'
    job.save!
  end

  def success(job)
    update_status(LogSpreadsheet::STATUS_SUCCEED, 'Export generated.')
    LogSpreadsheet.remove_old_spreadsheets
  end

  def error(job, exception)
    update_status(LogSpreadsheet::STATUS_ERRORED, "Export errored (\"#{exception}\"), trying again...")
  end

  def failure(job)
    update_status(LogSpreadsheet::STATUS_FAILED, 'Export failed. Please try again later.')
  end

  def perform
    spreadsheet = LogSpreadsheet.find(log_spreadsheet_id)
    spreadsheet.generate
  end

  private

  def update_status(status, status_msg)
    LogSpreadsheet.find(log_spreadsheet_id).update_status(status, status_msg)
  end
end
