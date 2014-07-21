class NotificationQueue
  include Mongoid::Document

  field :notify_at, type: DateTime

  belongs_to :incident
  belongs_to :notifier
end
