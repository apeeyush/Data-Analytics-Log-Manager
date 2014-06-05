json.array!(@documents) do |document|
  json.extract! document, :id, :name, :data
  json.url document_url(document, format: :json)
end
