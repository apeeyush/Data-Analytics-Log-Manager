class Log < ActiveRecord::Base

  # Takes a key, returns the corresponding value if key is a column name.
  # Otherwise searches parameters and extras for presence of key, and if present, returns the corresponding value.
  def value(key)
  	if self[key].present?
  		return self[key]
    elsif self[:parameters].present? && self[:parameters][key].present?
      return self[:parameters][key]
    elsif self[:extras].present? && self[:extras][key].present?
      return self[:extras][key]
  	else
  		return ""
  	end
  end

end
