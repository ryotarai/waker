json.array!(@notifiers) do |notifier|
  json.extract! notifier, :id, :user, :notify_after, :type, :details
  json.url notifier_url(notifier, format: :json)
end
