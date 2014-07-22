class Escalation < ActiveRecord::Base
  belongs_to :escalate_to, polymorphic: true
  belongs_to :escalation_rule
end
