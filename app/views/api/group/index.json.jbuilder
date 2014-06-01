json.array! @groups do |parent_name, logs|
  collection1 = [parent_name]
  collection = []
  logs.each do |log|
    collection << [ log["session"], log["username"], log["application"], log["activity"], log["event"], log["time"], log["parameters"], log["extras"] ]
  end
  collection1 << collection
  json.array!  collection1
end