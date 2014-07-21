class EscalationQueue
  include Mongoid::Document

  field :escalate_at, type: DateTime

  validates :escalate_at, presence: true
  validates :incident, presence: true
  validates :assignee, presence: true

  belongs_to :incident
  belongs_to :assignee, polymorphic: true # maybe User or Shift
end
