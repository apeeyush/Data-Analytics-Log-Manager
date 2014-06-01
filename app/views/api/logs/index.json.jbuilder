json.array! @logs do |log|
  json.session log.session
  json.username log.username
  json.application log.application
  json.activity log.activity
  json.event log.event
  json.time log.time
  if log.parameters.present?
    log.parameters.each do |key,value|
      json.set!(key,value)
    end
  end
  if log.extras.present?
  	log.extras.each do |key,value|
  	  json.set!(key,value)
  	end
  end
end
