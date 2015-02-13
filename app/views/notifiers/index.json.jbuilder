json.array!(@notifiers) do |notifier|
  json.extract! notifier, :id, :settings, :provider_id, :topic_id, :user_id, :notify_after_sec, :created_at, :updated_at
  json.url notifier_url(notifier, format: :json)
end
