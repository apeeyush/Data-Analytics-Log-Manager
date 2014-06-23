json.template @column_names

json.values @logs do |log|
  child = []
  @column_names.each do |column_name|
    child << log.value(column_name)
  end
  json.array! child
end