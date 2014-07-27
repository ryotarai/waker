json.array!(@providers) do |provider|
  json.extract! provider, :id, :name, :kind, :details, :escalation_rule_id
  json.url api_provider_url(provider, format: :json)
end
