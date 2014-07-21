json.array!(@incidents) do |incident|
  json.extract! incident, :id, :description, :details
  json.url incident_url(incident, format: :json)
end
