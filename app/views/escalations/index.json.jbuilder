json.array!(@escalations) do |escalation|
  json.extract! escalation, :id, :escalate_to_id, :escalate_after_sec, :escalation_series_id
  json.url escalation_url(escalation, format: :json)
end
