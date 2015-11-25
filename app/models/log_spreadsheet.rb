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
  # Max number of rows within one spreadsheet (so processing time and memory usage are reasonable).
  LOGS_COUNT_LIMIT = 600000
  # Time attributes need to be treated in a special way during spreadsheet generation.
  TIME_COLS = ['time', 'created_at', 'updated_at']

  STATUS_CREATED = 'created'
  STATUS_ENQUEUED = 'enqueued'
  STATUS_PROCESSING = 'processing'
  STATUS_SUCCEED = 'succeed'
  STATUS_ERRORED = 'errored' # encountered an unexpected error, but trying again
  STATUS_FAILED = 'failed'   # definite failure

  FIND_EACH_BATCH_SIZE = 5000
  UPDATE_BATCH_SIZE = 5000

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

    update_status(STATUS_PROCESSING, 'Generating and saving csv...')
    create_and_write_csv(column_names, logs)
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

  def append_to_file(data, reload_after_update=true)
    ActiveRecord::Base.connection.exec_query "UPDATE log_spreadsheets SET file = file || $1 WHERE id = $2", 'SQL', [[nil, data], [nil, id]]
    reload() if reload_after_update
  end

  private

  def create_and_write_csv(columns, logs)
    # reset the output to the headers so we can concat blocks of csv
    update_attributes!(file: columns.to_csv)

    rows = []
    row_idx = 1
    start_time = Time.now

    logs.find_each(batch_size: FIND_EACH_BATCH_SIZE) do |log|

      # add the row to the csv
      row = []
      columns.each do |col|
        row.push(log.value(col))
      end
      rows.push row.to_csv

      if row_idx % 2000 == 0
        rows_per_sec = (row_idx / (Time.now - start_time)).round
        update_status(STATUS_PROCESSING, "Generating spreadsheet (#{row_idx} rows, #{rows_per_sec} rows/sec)...")
      end

      # batch concat the csv without reloading it and then reset the rows for the next batch

      if row_idx % UPDATE_BATCH_SIZE == 0
        append_to_file rows.join(''), false
        rows = []
      end

      row_idx += 1
    end

    # add any remaining csv data and reload the file column by default
    append_to_file rows.join('')
  end

  def set_initial_status
    update_status(STATUS_CREATED, 'Spreadsheet generation job is waiting to be enqueued.')
  end

  def remove_old_spreadsheets
    limit = LogSpreadsheet.order(created_at: :desc).limit(SPREADSHEET_COUNT_LIMIT).last.created_at
    LogSpreadsheet.where('created_at < ?', limit).destroy_all
  end
end
