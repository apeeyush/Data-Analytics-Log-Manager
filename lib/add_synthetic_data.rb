module AddSyntheticData

  # Calculates the synthetic data to be added to the child table
  # Returns a list of computed logs
  def self.compute(logs, parent, synthetic_data, parents_list, child_keys)
    computed_logs = []
    if synthetic_data["rule"] != nil && synthetic_data["rule"]["pattern"] != nil
      pattern = synthetic_data["rule"]["pattern"]
    end
    if synthetic_data["result"] != nil
      result = synthetic_data["result"]
    end
    parents_list.each do |parent_name|
      child_logs = logs.where(parent => parent_name).order(:time)
      n = child_logs.count()
      m = pattern.length
      for i in 0..(n-m)
        j=0
        while j<m && child_logs[i+j].satisfies_conditions(pattern[j]) do
          j = j+1
        end
        if j==m
          index = result["clone"].to_i
          dup_log = child_logs[i+index].dup
          result["update_log"].each do |key, value|
            dup_log.update_value(key, value)
          end
          computed_logs << dup_log
        end
      end
    end
    return computed_logs
  end

end
