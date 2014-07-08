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

end
