class Log < ActiveRecord::Base

  # Takes a key, returns the corresponding value if key is a column name, otherwise 
  # searches parameters and extras for presence of key, and if present, returns the
  # corresponding value.
  #
  # Example:
  #  log = Log.first; session_value = log.value("session");
  def value(key)
  	if self[key].present?
      if self[key].class != ActiveSupport::TimeWithZone
  		  return self[key]
      else
        return self[key].to_i
      end
    elsif self[:parameters].present? && self[:parameters][key].present?
      return self[:parameters][key]
    elsif self[:extras].present? && self[:extras][key].present?
      return self[:extras][key]
  	else
  		return ""
  	end
  end

  # Filters data based on request_body["filter"]
  #
  # Example:
  #  logs = Log.all
  #  body = Hash.new; body["filter"] = Hash.new; body["filter"]["username"] = ["peeyush","apeeyush"];
  #  logs.filter(body)
  def self.filter(request_body)
    logs = self
    logger.debug(self)
    logs_columns = Hash.new
    Log.columns.each do |column|
      logs_columns[column.name] = column.type
    end
    string_columns = []
    time_columns = []
    hstore_columns = []
    logs_columns.except!("id")
    logs_columns.each do |column_name, type|
      if type == :string
        string_columns << column_name
      elsif type == :datetime
        time_columns << column_name
      elsif type == :hstore
        hstore_columns << column_name
      end
    end
    if (request_body["filter"] != nil)
      filter = request_body["filter"]
      string_columns.each do |string_column|
        if (filter[string_column] != nil && !filter[string_column].empty? )
          logs = logs.where({ string_column => filter[string_column]})
        end
      end
      time_columns.each do |time_column|
        if (filter[time_column] != nil && !filter[time_column].empty?)
         logs = logs.where("#{time_column} >= :start_time AND time <= :end_time",{start_time: filter["time"][0], end_time: filter["time"][1]})
        end
      end
      hstore_columns.each do |hstore_column|
        if (filter[hstore_column] != nil && filter[hstore_column]["keys"] != nil && !filter[hstore_column]["keys"].empty?)
          keys = filter[hstore_column]["keys"]
          keys.each do |key|
            logs = logs.where("#{hstore_column} ? :key", key: key)
          end
        end
        if (filter[hstore_column] != nil && filter[hstore_column]["pairs"] != nil && !filter[hstore_column]["pairs"].empty?)
          pairs = filter[hstore_column]["pairs"]
          pairs.each do |pair|
            key = pair.keys[0]
            value = pair[key]
            logs = logs.where("extras @> (:key => :value)", :key => key, :value => value)
          end
        end
      end
    end
    return logs
  end

end
