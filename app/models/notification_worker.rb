class NotificationWorker
  include Sidekiq::Worker

  def self.enqueue(event:, notifier:)
    Rails.logger.info "Enqueue NotificationWorker job"

    self.perform_in(notifier.notify_after_sec, event.id, notifier.id)
  end

  def perform(event_id, notifier_id)
    event = IncidentEvent.find(event_id)
    notifier = Notifier.find(notifier_id)

    notifier.notify_immediately(event)
  end
end

