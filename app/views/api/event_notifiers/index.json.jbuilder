json.array!(@event_notifiers) do |event_notifier|
  json.extract! event_notifier, :id, :kind, :details_json
  json.url event_notifier_url(event_notifier, format: :json)
end
