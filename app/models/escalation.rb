class Escalation < ActiveRecord::Base
  validates :escalate_to, presence: true
  validates :escalation_rule, presence: true
  validates :escalate_after, presence: true

  belongs_to :escalate_to, polymorphic: true
  belongs_to :escalation_rule
end
