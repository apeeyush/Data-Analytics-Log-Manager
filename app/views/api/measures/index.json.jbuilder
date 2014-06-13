# @groups:
# Hash:
# {
#	"parent_name_1" => {
#	  "parent_values" => [<parent_name_1>, <measure_1_value>, <measure_2_value>]
#   },
#   "parent_name_2" => {
#	  "parent_values" => [<parent_name_2>, <measure_1_value>, <measure_2_value>]
#   }, ......
# }
#
{""=>{"parent_values"=>["", 1]}, "apeeyush"=>{"parent_values"=>["apeeyush", 2]}, "peeyush"=>{"parent_values"=>["peeyush", 15]}, "Peeyush"=>{"parent_values"=>["Peeyush", 1]}, nil=>{"parent_values"=>[nil, 74]}}
json.template @column_names
json.values @groups do |parent_value, group|
  json.array! group["parent_values"]
end
