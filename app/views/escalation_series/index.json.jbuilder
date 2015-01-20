json.array!(@escalation_series) do |escalation_series|
  json.extract! escalation_series, :id, :name
  json.url escalation_series_url(escalation_series, format: :json)
end
