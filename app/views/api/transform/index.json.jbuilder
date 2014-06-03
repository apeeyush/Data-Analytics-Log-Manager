json.template do
  json.parent_keys @parent_keys
  json.child_keys @child_keys
end
json.groups @groups do |parent_name, logs|
  parent_collection = [parent_name]
  child_collection = []
  logs.each do |log|
  	child = []
  	@child_keys.each do |child_key|
    	child << log.value(child_key)
    end
    child_collection << child
  end
  child_collection_hash = Hash.new
  child_collection_hash["children"] = child_collection
  parent_collection << child_collection_hash
  json.array!  parent_collection
end