json.array!(@notifiers) do |notifier|
  json.extract! notifier, :id, :type, :settings, :notify_after_sec
  json.url notifier_url(notifier, format: :json)
end
