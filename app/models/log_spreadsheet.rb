# == Schema Information
#
# Table name: log_spreadsheets
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  status      :string(255)
#  status_msg  :string(255)
#  query       :text
#  file        :binary
#  created_at  :datetime
#  updated_at  :datetime
#
class LogSpreadsheet < ActiveRecord::Base
  LOGS_COUNT_LIMIT = 65536 # old Excel limit and quite reasonable value to avoid too long processing time

  STATUS_CREATED = 'created'
  STATUS_ENQUEUED = 'enqueued'
  STATUS_PROCESSING = 'processing'
  STATUS_SUCCEED = 'succeed'
  STATUS_ERRORED = 'errored' # encountered an unexpected error, but trying again
  STATUS_FAILED = 'failed'   # definite failure

  belongs_to :user

  after_create :set_initial_status

  def generate
    raise StandardError.new('Failed to process spreadsheet without JSON query') unless query

    update_status(STATUS_PROCESSING, 'Processing started...')

    column_names = Log.column_names - %w{id}
    column_names = column_names.flatten.uniq

    update_status(STATUS_PROCESSING, 'Executing SQL query...')
    logs = Log.execute_query(query, user)

    update_status(STATUS_PROCESSING, 'Generating spreadsheet...')
    book = create_spreadsheet(column_names, logs)

    update_status(STATUS_PROCESSING, 'Saving spreadsheet...')
    io = StringIO.new
    book.write io
    update_attributes!(file: io.string.force_encoding('binary'))
  end

  def update_status(status, status_msg)
    update_attributes!(status: status, status_msg: status_msg)
  end

  def logs_count
    Log.execute_query(query, user).count
  end

  def too_big?
    logs_count > LOGS_COUNT_LIMIT
  end

  private

  def create_spreadsheet(columns, logs)
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet name: "Logs #{Time.now}"
    sheet.row(0).concat(columns)
    row_idx = 1
    logs.find_each do |log|
      if row_idx % 500 == 0
        update_status(STATUS_PROCESSING, "Generating spreadsheet (#{row_idx} rows)...")
      end
      if row_idx > 10000
        raise StandardError.new('Random error')
      end
      row = sheet.row(row_idx)
      columns.each do |col|
        row.push(log[col])
      end
      row_idx += 1
    end
    book
  end

  def set_initial_status
    update_status(STATUS_CREATED, 'Spreadsheet generation job is waiting to be enqueued.')
  end
end
