module AddMeasure

  # Calculates count of number of logs (after filtering) for each parent in parents_list
  # grouped by parent
  def self.calculate_count(measure_details, logs, parent, parents_list)
    logs = logs.filter(measure_details["filter"]) if measure_details["filter"].present?
    logs = logs.filter_having_keys(measure_details["filter_having_keys"]) if measure_details["filter_having_keys"].present?
    measures_data = logs.select("#{parent}, count(*) as count_measure").group(parent).order(parent)
    measures_hash = Hash.new
    done_parents = []
    measures_data.each do |values|
      done_parents << values[parent]
      measures_hash[values[parent]] = values["count_measure"]
    end
    left_parents = parents_list - done_parents
    left_parents.each do |left_parent|
      measures_hash[left_parent] =  "0"
    end
    return measures_hash
  end

  # Returns a hash with parent_name as key and first log's value for each group as value
  def self.calculate_values(measure_details, logs, parent, parents_list)
    measures_hash = Hash.new
    logs = logs.filter(measure_details["filter"]) if measure_details["filter"].present?
    logs = logs.filter_having_keys(measure_details["filter_having_keys"]) if measure_details["filter_having_keys"].present?
    first_logs = logs.select("DISTINCT ON (#{parent}) *").order(parent, :time)
    done_parents = []
    first_logs.each do |log|
      done_parents << log[parent]
      measures_hash[log[parent]] = log.value(measure_details["key"])
    end
    left_parents = parents_list - done_parents
    left_parents.each do |left_parent|
      measures_hash[left_parent] =  ""
    end
    return measures_hash
  end

  # Calculates sum of values of logs (after filtering) for each parent in parents_list
  # grouped by parent
  def self.calculate_sum(measure_details, logs, parent, parents_list)
    logs_columns = Log.column_lists
    hstore_columns = logs_columns["hstore_columns"]
    measures_hash = Hash.new
    logs = logs.filter(measure_details["filter"]) if measure_details["filter"].present?
    logs = logs.filter_having_keys(measure_details["filter_having_keys"]) if measure_details["filter_having_keys"].present?
    key = measure_details["key"]
    key.gsub!(/[^0-9A-Za-z]/, '')
    # Alert: There is no way to pass variable as placeholder in sum.
    # 'key' which is a user input is being user in the query direcly.
    # Hence all special characters have been removed from key using gsub!.
    # sum_hash = logs.group(parent).sum("(#{hstore_columns} -> ? )::float", key) does not work
    sum_hash = logs.group(parent).sum("(#{hstore_columns} -> '#{key}' )::float")
    done_parents = []
    sum_hash.each do |key, value|
      done_parents << key
      measures_hash[key] = value
    end
    left_parents = parents_list - done_parents
    left_parents.each do |left_parent|
      measures_hash[left_parent] =  ""
    end
    return measures_hash
  end

end
