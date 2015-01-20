class Notifier < ActiveRecord::Base
  belongs_to :provider, class: NotifierProvider
  belongs_to :user

  validates :user, presence: true
  validates :provider, presence: true
  validates :notify_after_sec, numericality: {greater_than_or_equal_to: 0}

  after_initialize :set_defaults

  def set_defaults
    self.settings ||= {}
  end

  def notify(incident, event)
    NotificationWorker.enqueue(incident, self, event)
  end

  def notify_immediately(incident, event)
    # check event type

    provider.notify(self, incident, event)
  end
end

