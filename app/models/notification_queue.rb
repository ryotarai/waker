class NotificationQueue < ActiveRecord::Base
  validates :notifier, presence: true
  validates :incident, presence: true
  validates :notify_at, presence: true

  belongs_to :notifier
  belongs_to :incident
end
