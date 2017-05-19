# == Schema Information
#
# Table name: log_spreadsheets
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  status      :string(255)
#  status_msg  :string(255)
#  query       :text
#  file        :text
#  all_columns :boolean
#  format      :string ("csv" or "json")
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

  # DO NOT load 'file' field by default, as it might be huge. Use #file_chunk instead!
  default_scope { select(LogSpreadsheet.attribute_names.select { |x| x != 'file' }) }

  def self.count
    # Default scope is breaking #count.
    LogSpreadsheet.unscoped.count
  end

  def self.remove_old_spreadsheets
    keep = LogSpreadsheet.order(created_at: :desc).limit(SPREADSHEET_COUNT_LIMIT)
    if keep.length > 0
      limit = keep.last.created_at
      # delete any LogSpreadsheet created before those in our keep set
      LogSpreadsheet.where('created_at < ?', limit).delete_all
    end
  end

  def generate
    raise StandardError.new('Failed to process export without JSON query') unless query

    update_status(STATUS_PROCESSING, 'Executing SQL query...')

    total   = Log.execute_query(query, user).count
    logs    = Log.execute_query(query, user)

    if format == "json"
      update_status(STATUS_PROCESSING,
                    "Generating and saving json... (#{total} total rows)")
      create_and_write_json(logs, total)
    else
      if all_columns
        column_names = logs.keys_list Log::ALL_COLUMNS
      else
        column_names = logs.keys_list
      end

      update_status(STATUS_PROCESSING,
                    "Generating and saving csv... (#{total} total rows)")
      create_and_write_csv(column_names, logs, total)
    end
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
    # Warning: that's memory efficient, but when 'file' grows, this call gets slower and slower.
    #          So, probably SQL server is reloading file content each time anyway.
    ActiveRecord::Base.connection.exec_query "UPDATE log_spreadsheets SET file = file || $1 WHERE id = $2", 'SQL', [[nil, data], [nil, id]]
    reload() if reload_after_update
  end

  def file_length
    result = ActiveRecord::Base.connection.exec_query "SELECT CHAR_LENGTH(file) from log_spreadsheets WHERE id = $1", 'SQL', [[nil, id]]
    result.rows[0][0].to_i
  end

  def file_chunk(offset = 0, chunk_size = 16777216) # chunk_size = 16MB
    result = ActiveRecord::Base.connection.exec_query "SELECT SUBSTRING(file from CAST($1 AS INTEGER) for CAST($2 AS INTEGER)) from log_spreadsheets WHERE id = $3",
                                                      'SQL', [[nil, offset], [nil, chunk_size], [nil, id]]
    result.rows[0][0]
  end

  def for_file_chunks(chunk_size = 16777216) # chunk_size = 16MB
    offset = 0
    frag = file_chunk(offset, chunk_size)
    while frag != ""
      yield frag
      offset += chunk_size
      frag = file_chunk(offset, chunk_size)
    end
  end

  private

  def create_and_write_csv(columns, logs, total)
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
        update_status(  STATUS_PROCESSING,
                        "Generating export (#{row_idx}/#{total} rows, #{rows_per_sec} rows/sec)... ")
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

  def create_and_write_json(logs, total)
    update_attributes!(file: "[\n")

    rows = []
    row_idx = 1
    start_time = Time.now
    batch_count = 0

    logs.find_each(batch_size: FIND_EACH_BATCH_SIZE) do |log|

      # add the row to the json array
      rows.push "  #{log.to_json(:except => [:created_at, :updated_at])}"

      if row_idx % 2000 == 0
        rows_per_sec = (row_idx / (Time.now - start_time)).round
        update_status(  STATUS_PROCESSING,
                        "Generating export (#{row_idx}/#{total} rows, #{rows_per_sec} rows/sec)...")
      end

      # batch concat the csv without reloading it and then reset the rows for the next batch

      if row_idx % UPDATE_BATCH_SIZE == 0
        append_to_file ",\n", false if batch_count > 0 # add comma between batches
        append_to_file rows.join(",\n"), false
        rows = []
        batch_count = batch_count + 1
      end

      row_idx += 1
    end

    # add any remaining csv data and reload the file column by default
    append_to_file ",\n", false if batch_count > 0 # add comma between batches
    append_to_file rows.join(",\n"), false
    append_to_file "\n]", true
  end

  def set_initial_status
    update_status(STATUS_CREATED, 'Export job is waiting to be enqueued.')
  end
end
