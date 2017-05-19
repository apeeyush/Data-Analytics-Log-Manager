# == Schema Information
#
# Table name: logs
#
#  id          :integer          not null, primary key
#  session     :string(255)
#  username    :string(255)
#  application :string(255)
#  activity    :string(255)
#  event       :string(255)
#  time        :datetime
#  parameters  :hstore
#  extras      :hstore
#  created_at  :datetime
#  updated_at  :datetime
#  event_value :string(255)
#
class Log < ActiveRecord::Base

  ALL_COLUMNS = true

  #
  # Define size of "large" filter lists which might be handled
  # differently than other filters.
  #
  LARGE_FILTER_LIST_SIZE = 5

  # Select logs for user based on user's application list
  scope :access_filter, lambda { |user|
      where(application: user.applications.pluck(:name) )
  }

  # Returns a hash with key as column_type and value as lists of names of that column_type
  #
  # Example:
  #   Log.column_lists
  #   Returns:
  #     {
  #       "string_columns"=>["session", "username", "application", "activity", "event"],
  #       "time_columns"=>["time", "created_at", "updated_at"],
  #       "hstore_columns"=>"parameters || extras"
  #     }
  def self.column_lists
    string_columns, time_columns, hstore_concat_string = [], [], ""
    columns_hash = Hash.new
    Log.columns.each do |column|
      columns_hash[column.name] = column.type
    end
    columns_hash.except!("id")
    columns_hash.each do |column_name, type|
      if type == :string
        string_columns << column_name
      elsif type == :datetime
        time_columns << column_name
      elsif type == :hstore
        hstore_concat_string == "" ? hstore_concat_string << column_name : hstore_concat_string << " || " + column_name
      end
    end
    logs_columns = Hash.new
    logs_columns["string_columns"] = string_columns
    logs_columns["time_columns"] = time_columns
    logs_columns["hstore_columns"] = hstore_concat_string
    return logs_columns
  end

  # Takes a key, returns the corresponding value if key is a column name, otherwise
  # searches parameters and extras for presence of key, and if present, returns the
  # corresponding value.
  #
  # Example:
  #  log = Log.first; session_value = log.value("session");
  def value(key)
    if self[key].present?
      self[key].class != ActiveSupport::TimeWithZone ? self[key] : self[key].to_f
    elsif self[:parameters].present? && self[:parameters][key].present?
      return self[:parameters][key]
    elsif self[:extras].present? && self[:extras][key].present?
      return self[:extras][key]
    else
      return ""
    end
  end

  def update_value(key, value)
    new_log = self
    logs_columns = Log.column_lists
    if logs_columns["string_columns"].include? key #|| logs_columns["time_columns"].include? key
      new_log[key] = value
    else
      new_log[:parameters][key] = value
    end
    return new_log
  end

  # Executes JSON query and returns logs set.
  # Both parsed and unparsed query JSON are accepted.
  def self.execute_query(query, user)
    query = JSON.parse(ERB::Util.json_escape(query)) if query.is_a?(String)
    # Apply filters on logs.
    logs = Log.access_filter(user)
    logs = logs.filter(query["filter"]) if (query["filter"].present?)
    logs = logs.filter_having_keys(query["filter_having_keys"]) if (query["filter_having_keys"].present? && query["filter_having_keys"]["keys_list"].present?)
    logs
  end

  #
  # Filters data having specified values/range for the keys
  #
  # Example JSON Body:
  #   [
  #     {
  #       "key" : "username",
  #       "list" : ["peeyush", "apeeyush"]
  #     },
  #     {
  #       "key" : "time",
  #       "start_time" : "2014-02-25",
  #       "end_time" : "2014-10-29"
  #     },
  #     {
  #       "key" : "color"
  #       "remove" : true,                                  //Optional (For filter out)
  #       "list" : ["green"]
  #     }
  #   ]
  #   logs.filter(body)
  #
  def self.filter(filter_list)

    logs = self

    logs_columns    = Log.column_lists
    string_columns  = logs_columns["string_columns"]
    time_columns    = logs_columns["time_columns"]
    hstore_columns  = logs_columns["hstore_columns"]

    where_clause_filters = []

    #
    # Check for special keys we handle in JOIN prior to WHERE clause.
    # Should this be generic and handle *all* keys where list size is
    # greater than some value?
    #
    # This should be used for filter lists that are too large to fit
    # in the WHERE clause's IN (...) block.
    #
    filter_list.each do |filter|

        key     = filter['key']
        list    = filter['list']
        remove  = filter['remove']

        if  key == 'run_remote_endpoint'        &&
            list.size > LARGE_FILTER_LIST_SIZE  &&
            remove != true

            #
            # Create SQL safe strings for key and values
            #
            clean_key = Log.connection.quote_string(key)
            clean_item_list = []
            list.each do |item|
                clean_item_list.push(Log.connection.quote_string(item))
            end

            #
            # Create join values
            #
            join_sql =  "INNER JOIN ( "
            join_sql << "   VALUES "
            join_sql << "       ('" << clean_item_list.join("'), ('") << "') "
            join_sql << "   ) vals(v) ON "
            join_sql << "( #{hstore_columns} -> '#{clean_key}' ) = v"

            logs = logs.joins(join_sql)

        else 

            #
            # Otherwise, handle this below in where clause.
            #
            where_clause_filters.push(filter)

        end

    end

    #
    # Handle remaining filters here.
    #
    where_clause_filters.each do |filter|

      key = filter["key"]

      if string_columns.include? key
        if filter["remove"] == true
          logs = logs.where.not({ key => filter["list"]})
        else
          logs = logs.where({ key => filter["list"]})
        end
      elsif time_columns.include? key
        if filter["start_time"].present? && !filter["end_time"].present?
          logs = logs.where("#{key} >= :start_time",{start_time: filter["start_time"]})
        elsif filter["end_time"].present? && !filter["start_time"].present?
          logs = logs.where("#{key} <= :end_time",{end_time: filter["end_time"]})
        elsif filter["end_time"].present? && filter["start_time"].present?
          logs = logs.where("#{key} >= :start_time AND #{key} <= :end_time",{start_time: filter["start_time"], end_time: filter["end_time"]})
        end
      else
        if filter["remove"] == true
          logs = logs.where("#{hstore_columns} -> :key NOT IN ( :list )", :key => key, :list => filter["list"])
        else
          logs = logs.where("#{hstore_columns} -> :key IN ( :list )", :key => key, :list => filter["list"])
        end
      end
    end
    return logs
  end

  # Filters data having specified keys
  #
  # Example JSON Body:
  #   {
  #     "keys_list" : ["event","color"]
  #   }
  def self.filter_having_keys(filter)
    logs = self
    logs_columns = Log.column_lists
    string_columns = logs_columns["string_columns"]
    time_columns = logs_columns["time_columns"]
    hstore_columns = logs_columns["hstore_columns"]
    if filter["keys_list"].present?
      list = filter["keys_list"]
      additional_keys = []
      list.each do |key|
        if string_columns.include? key or time_columns.include? key
          logs = logs.where("#{key} IS NOT NULL")
        else
          additional_keys << key
        end
      end
      if additional_keys.any?
        logs = logs.where("#{hstore_columns} ?& ARRAY[:additional_keys]", additional_keys: additional_keys)
      end
    end
    return logs
  end

  # Returns the list of keys for logs except id
  #
  # Example:
  #   Log.keys_list
  def self.keys_list(all_possible=false)
    ids = all.pluck(:id)
    list = Log.column_names - %w{id parameters extras}
    if ids.size > 0

      # include all ids with the same application/activity pair so that all the possible parameters and extras are included
      if all_possible
        ids << (Log.connection.execute("SELECT id FROM logs WHERE application IN (SELECT DISTINCT application FROM logs WHERE id in (#{ids.join(',')})) AND activity IN (SELECT DISTINCT activity FROM logs WHERE id in (#{ids.join(',')}))").values.flatten rescue [])
        ids = ids.flatten.uniq
      end

      list << (Log.connection.execute("SELECT DISTINCT (each(parameters)).key FROM logs WHERE id in (#{ids.join(',')})").values.flatten rescue [])
      list << (Log.connection.execute("SELECT DISTINCT (each(extras)).key     FROM logs WHERE id in (#{ids.join(',')})").values.flatten rescue [])
    end
    list.flatten.uniq
  end

  def satisfies_conditions(conditions)
    conditions.each do |key, value|
      return false if value(key) != value
    end
    return true
  end

end
