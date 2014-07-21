json.array!(@escalations) do |escalation|
  json.extract! escalation, :id, :rule
  json.url escalation_url(escalation, format: :json)
end
