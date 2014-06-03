class Log < ActiveRecord::Base

  def value(key)
  	if self[key].present?
  		return self[key]
  	elsif self[:parameters].present? && self[:parameters][key].present?
  		return self[:parameters][key]
  	elsif self[:extras].present? && self[:extras][key].present?
  		return self[:parameters][key]
  	else
  		return ""
  	end
  end

end
