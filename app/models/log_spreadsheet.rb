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
#  all_columns :boolean
#  created_at  :datetime
#  updated_at  :datetime
#
class LogSpreadsheet < ActiveRecord::Base
  # Max number of LogSpreadsheet rows stored in DB.
  # Generated spreadsheet files can be pretty heavy, so don't store too many of them.
  SPREADSHEET_COUNT_LIMIT = 10
  # Max number of rows within one spreadsheet.
  # Use old Excel limit, it's quite reasonable value so we should avoid too long processing time.
  LOGS_COUNT_LIMIT = 65536
  # Time attributes need to be treated in a special way during spreadsheet generation.
  TIME_COLS = ['time', 'created_at', 'updated_at']

  STATUS_CREATED = 'created'
  STATUS_ENQUEUED = 'enqueued'
  STATUS_PROCESSING = 'processing'
  STATUS_SUCCEED = 'succeed'
  STATUS_ERRORED = 'errored' # encountered an unexpected error, but trying again
  STATUS_FAILED = 'failed'   # definite failure

  belongs_to :user

  after_create :set_initial_status
  after_create :remove_old_spreadsheets

  def generate
    raise StandardError.new('Failed to process spreadsheet without JSON query') unless query

    update_status(STATUS_PROCESSING, 'Executing SQL query...')
    logs = Log.execute_query(query, user)

    if all_columns
      column_names = logs.keys_list Log::ALL_COLUMNS
    else
      column_names = logs.keys_list
    end

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
      if row_idx % 2000 == 0
        update_status(STATUS_PROCESSING, "Generating spreadsheet (#{row_idx} rows)...")
      end
      row = sheet.row(row_idx)
      columns.each do |col|
        if TIME_COLS.include?(col)
          val = log[col].to_datetime
        else
          val = log.value(col)
        end
        row.push(val)
      end
      row_idx += 1
    end
    book
  end

  def set_initial_status
    update_status(STATUS_CREATED, 'Spreadsheet generation job is waiting to be enqueued.')
  end

  def remove_old_spreadsheets
    limit = LogSpreadsheet.order(created_at: :desc).limit(SPREADSHEET_COUNT_LIMIT).last.created_at
    LogSpreadsheet.where('created_at < ?', limit).destroy_all
  end
end
