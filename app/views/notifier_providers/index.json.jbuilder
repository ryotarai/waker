json.array!(@notifier_providers) do |notifier_provider|
  json.extract! notifier_provider, :id, :name, :kind, :settings
  json.url notifier_provider_url(notifier_provider, format: :json)
end
