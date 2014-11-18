json.array!(@crews) do |crew|
  json.extract! crew, :id
  json.url crew_url(crew, format: :json)
end
