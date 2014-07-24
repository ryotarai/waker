class EscalationQueue < ActiveRecord::Base
  validates :incident, presence: true
  validates :escalation, presence: true
  validates :escalate_at, presence: true

  belongs_to :incident
  belongs_to :escalation
  
  def self.process
    self.where('escalate_at < ?', Time.now).each do |job|
      case job.escalation.escalate_to
      when User
        escalate_to = job.escalation.escalate_to
      else
        next
      end

      # add job to notification queue
      current_time = Time.now
      escalate_to.notifiers.each do |notifier|
        NotificationQueue.create!(
          notifier: notifier,
          incident: job.incident,
          notify_at: current_time + notifier.notify_after,
        )
      end

      job.destroy
    end
  end
end
