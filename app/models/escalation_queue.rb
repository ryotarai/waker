class EscalationQueue < ActiveRecord::Base
  validates :incident, presence: true
  validates :escalation, presence: true
  validates :escalate_at, presence: true

  belongs_to :incident
  belongs_to :escalation
  
  def self.process
    self.where('escalate_at < ?', Time.now).each do |job|
      if job.incident.opened?
        user = job.escalation.user_escalate_to
        Rails.logger.info "Escalating #{job.incident.inspect} to #{user.inspect}."
        current_time = Time.now
        user.notifiers.each do |notifier|
          NotificationQueue.create!(
            notifier: notifier,
            incident: job.incident,
            notify_at: current_time + notifier.notify_after,
          )
        end
      end

      job.destroy
    end
  end
end
