class Log < ActiveRecord::Base

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
      self[key].class != ActiveSupport::TimeWithZone ? self[key] : self[key].to_i
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

  # Filters data having specified values/range for the keys
  #
  # Example JSON Body:
  #     "username" : {
  #       "list" : ["peeyush", "apeeyush"]
  #     },
  #     "time" : {
  #       "start_time" : "2014-02-25",
  #       "end_time" : "2014-10-29"
  #     },
  #     "color" : {
  #       "type" : "remove",                               //Optional (For filter out)
  #       "list" : [ {"color":"green"}]      
  #     }
  #  logs.filter(body)
  def self.filter(filter)
    logs = self
    logs_columns = Log.column_lists
    string_columns = logs_columns["string_columns"]
    time_columns = logs_columns["time_columns"]
    hstore_columns = logs_columns["hstore_columns"]
    filter.each do |key, value|
      if string_columns.include? key
        if value["type"] == "remove"
          logs = logs.where.not({ key => value["list"]})
        else
          logs = logs.where({ key => value["list"]})
        end
      elsif time_columns.include? key
        if value["start_time"].present? && !value["end_time"].present?
          logs = logs.where("#{key} >= :start_time",{start_time: value["start_time"]})
        elsif value["end_time"].present? && !value["start_time"].present?
          logs = logs.where("#{key} <= :end_time",{end_time: value["end_time"]})
        elsif value["end_time"].present? && value["start_time"].present?
          logs = logs.where("#{key} >= :start_time AND #{key} <= :end_time",{start_time: value["start_time"], end_time: value["end_time"]})
        end
      else
        if value["type"] == "remove"
          logs = logs.where("#{hstore_columns} -> :key NOT IN ( :list )", :key => key, :list => value["list"])
        else
          logs = logs.where("#{hstore_columns} -> :key IN ( :list )", :key => key, :list => value["list"])
        end
      end
    end
    return logs
  end

  # Filters data having specified keys
  #
  # Example JSON Body:
  #   "keys" : {
  #     "list" : ["event","color"]
  #   }
  def self.filter_having_keys(filter)
    logs = self
    logs_columns = Log.column_lists
    string_columns = logs_columns["string_columns"]
    time_columns = logs_columns["time_columns"]
    hstore_columns = logs_columns["hstore_columns"]
    if filter["keys"].present? && filter["keys"]["list"].present?
      list = filter["keys"]["list"]
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
  def self.keys_list
    list = Log.column_names - %w{id parameters extras}
    all.each do |log|
      log.parameters.present? ? list << log.parameters.keys : list << []
      log.extras.present? ? list << log.extras.keys : list << []
    end
    list = list.flatten.uniq
    return list
  end

  def satisfies_conditions(conditions)
    conditions.each do |key, value|
      return false if value(key) != value
    end
    return true
  end

end
