json.template @column_names
json.values @groups do |parent_value, group|
  json.array! group["parent_values"]
end
