json.array!(@incidents) do |incident|
  json.extract! incident, :id, :description, :details, :status
  json.provider incident.provider.as_json(methods: [:details], except: [:details_json])
  json.url incident_url(incident, format: :json)
end
