json.array!(@data_queries) do |data_query|
  json.extract! data_query, :id, :name, :content
  json.url data_query_url(data_query, format: :json)
end
