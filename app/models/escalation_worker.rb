class EscalationWorker
  include Sidekiq::Worker

  def self.enqueue(incident, escalation)
    Rails.logger.info "Enqueue EscalaionWorker job"
    self.perform_in(escalation.escalate_after_sec, incident.id, escalation.id)
  end

  def perform(incident_id, escalation_id)
    incident = Incident.find(incident_id)
    escalation = Escalation.find(escalation_id)

    if incident.opened?
      incident.events.create(
        kind: :escalated,
        info: {
          escalation: escalation,
          escalated_to: escalation.escalate_to,
        },
      )
    end
  end
end
