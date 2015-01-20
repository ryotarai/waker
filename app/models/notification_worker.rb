class NotificationWorker
  include Sidekiq::Worker

  def self.enqueue(incident, notifier, event)
    Rails.logger.info "Enqueue NotificationWorker job"
    self.perform_in(notifier.notify_after_sec, incident.id, notifier.id, event)
  end

  def perform(incident_id, notifier_id, event)
    incident = Incident.find(incident_id)
    notifier = Notifier.find(notifier_id)

    notifier.notify_immediately(incident, event)
  end
end

