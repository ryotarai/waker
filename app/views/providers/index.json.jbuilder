json.array!(@providers) do |provider|
  json.extract! provider, :id, :name, :kind, :details
  json.url provider_url(provider, format: :json)
end
