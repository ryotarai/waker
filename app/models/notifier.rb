class Notifier < ActiveRecord::Base
  belongs_to :provider, class: NotifierProvider
  belongs_to :user
  belongs_to :topic

  validates :provider, presence: true
  validates :notify_after_sec, numericality: {greater_than_or_equal_to: 5}

  serialize :settings, JSON
  after_initialize :set_defaults

  def set_defaults
    self.settings ||= {}
  end

  def notify(event)
    NotificationWorker.enqueue(event: event, notifier: self)
  end

  def notify_immediately(event)
    provider.notify(event: event, notifier: self)
  end
end

