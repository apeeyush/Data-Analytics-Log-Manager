# template:
# @parent_keys
# @child_keys
#
# @groups:
# Hash:
# {
# "parent_name_1" => {
#   "parent_values" => [<parent_name_1>, <measure_1_value>, <measure_2_value>]
#   "child_values" => [["child1_value1","child1_value2"],["child2_value1","child2_value2"]]
#   },
#   "parent_name_2" => {
#   "parent_values" => [<parent_name_2>, <measure_1_value>, <measure_2_value>]
#   }, ......
# }
json.template do
  json.parent_keys @parent_keys
  json.child_keys @child_keys
end
json.groups @groups do |parent_name, data|
  parent_collection = data["parent_values"]
  child_collection = data["child_values"] || []
  json.parent_values  parent_collection
  json.child_values child_collection
end
