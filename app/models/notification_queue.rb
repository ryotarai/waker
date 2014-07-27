class NotificationQueue < ActiveRecord::Base
  validates :notifier, presence: true
  validates :incident, presence: true
  validates :notify_at, presence: true

  belongs_to :notifier
  belongs_to :incident

  def self.process
    # fetch jobs from notification queue and notify it
    self.where('notify_at < ?', Time.now).each do |job|
      Rails.logger.info "#{job.notifier.inspect} notifies #{job.incident.inspect}"

      if job.incident.opened?
        job.notifier.notify(job.incident)
      end
      job.destroy
    end
  end
end
