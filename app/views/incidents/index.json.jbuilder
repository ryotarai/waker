json.array!(@incidents) do |incident|
  json.extract! incident, :id, :subject, :description, :topic_id, :occured_at
  json.url incident_url(incident, format: :json)
end
