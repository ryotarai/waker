json.array!(@providers) do |provider|
  json.extract! provider, :id, :name, :kind, :details, :escalation_rule_id
  json.url provider_url(provider, format: :json)
end
