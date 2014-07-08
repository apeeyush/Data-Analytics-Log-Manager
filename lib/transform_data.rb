module TransformData

  # Reformats children logs and returns array of array where internal array contains 
  # values for a log in the order of child_keys.
  def self.transform_child_data(logs, parent_name, child_keys)
    children_collection = []
    logs.each do |log|
      child = []
      child_keys.each do |child_key|
        child << log.value(child_key)
      end
      children_collection << child
    end
    return children_collection
  end

end
