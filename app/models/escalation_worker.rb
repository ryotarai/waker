class EscalationWorker
  include Sidekiq::Worker

  def self.enqueue(incident, escalation)
    Rails.logger.info "Enqueue EscalaionWorker job"
    self.perform_in(escalation.escalate_after_sec, incident.id, escalation.id)
  end

  def perform(incident_id, escalation_id)
    incident = Incident.find(incident_id)
    escalation = Escalation.find(escalation_id)

    escalation.escalate_to.notifiers.each do |notifier|
      notifier.notify(incident, :escalated_to_me)
    end

    Notifier.all.each do |notifier|
      notifier.notify(incident, :escalated)
    end
  end
end

