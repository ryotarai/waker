class EscalationQueue < ActiveRecord::Base
  validates :incident, presence: true
  validates :escalation, presence: true
  validates :escalate_at, presence: true

  belongs_to :incident
  belongs_to :escalation
end
