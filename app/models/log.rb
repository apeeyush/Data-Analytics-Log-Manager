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
  # Example JSON Body:
  # {
  #   "filter" : {
  #     "username" : {
  #       "list" : ["peeyush", "apeeyush"]
  #     },
  #     "time" : ["start time","end time"],
  #     "parameters" : {
  #       "keys" : {
  #         "type" : "remove",                               //Optional (For filter out)
  #         "list" : ["color"]
  #       },
  #       "pairs": {
  #         "type" : "remove"                                //Optional (For filter out)
  #         "list" : [ {"color":"green"}]      
  #       } 
  #     }
  #   }
  # }
  #  logs.filter(body)
  def self.filter(filter)
    logs = self
    logs_columns = Hash.new
    Log.columns.each do |column|
      logs_columns[column.name] = column.type
    end
    string_columns = []
    time_columns = []
    hstore_columns = ""
    logs_columns.except!("id")
    logs_columns.each do |column_name, type|
      if type == :string
        string_columns << column_name
      elsif type == :datetime
        time_columns << column_name
      elsif type == :hstore
        hstore_columns == "" ? hstore_columns << column_name : hstore_columns << " || " + column_name
      end
    end
    logger.debug(hstore_columns)
    string_columns.each do |string_column|
      if (filter[string_column] != nil && !filter[string_column].empty? )
        if filter[string_column]["type"] == "remove"
          logs = logs.where.not({ string_column => filter[string_column]["list"]})
        else
          logs = logs.where({ string_column => filter[string_column]["list"]})
        end
      end
    end
    time_columns.each do |time_column|
      if (filter[time_column] != nil && !filter[time_column].empty?)
       logs = logs.where("#{time_column} >= :start_time AND time <= :end_time",{start_time: filter["time"][0], end_time: filter["time"][1]})
      end
    end
    if (filter["others"] != nil && filter["others"]["keys"] != nil && !filter["others"]["keys"].empty? && !filter["others"]["keys"]["list"].empty?)
      keys = filter["others"]["keys"]
      if keys["type"] == "remove"
        logs = logs.where("NOT #{hstore_columns} ?& ARRAY[:keys]", keys: keys["list"])
      else
        logs = logs.where("#{hstore_columns} ?& ARRAY[:keys]", keys: keys["list"])
      end
    end
    if (filter["others"] != nil && filter["others"]["pairs"] != nil && !filter["others"]["pairs"].empty?)
      pairs = filter["others"]["pairs"]
      if pairs["type"] == "remove"
        pairs["list"].each do |pair|
          key = pair.keys[0]
          logs = logs.where.not("#{hstore_columns} @> hstore(:key,:value)", :key => pair.keys[0], :value => pair[key])
        end
      else
        pairs["list"].each do |pair|
          key = pair.keys[0]
          logs = logs.where("#{hstore_columns} @> hstore(:key,:value)", :key => pair.keys[0], :value => pair[key])
        end
      end
    end
    return logs
  end

end
