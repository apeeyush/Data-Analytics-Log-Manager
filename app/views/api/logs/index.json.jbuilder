json.array! @logs do |log|
  json.session log.session
  json.user log.user
  json.application log.application
  json.activity log.activity
  json.event log.event
  json.time log.time
  json.parameters log.parameters
  if log.extras.present?
  	log.extras.each do |key,value|
  	  json.set!(key,value)
  	end
  end
end
