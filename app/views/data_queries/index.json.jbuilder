json.array!(@data_queries) do |data_query|
  json.extract! data_query, :id, :content, :user_id
  json.url data_query_url(data_query, format: :json)
end
