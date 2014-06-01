json.array!(@logs) do |log|
  json.extract! log, :id, :session, :username, :application, :activity, :event, :time, :parameters, :extras
  json.url log_url(log, format: :json)
end
