json.array!(@providers) do |provider|
  json.extract! provider, :id, :type, :details
  json.url provider_url(provider, format: :json)
end
