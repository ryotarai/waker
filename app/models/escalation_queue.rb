class EscalationQueue < ActiveRecord::Base
  belongs_to :incident
  belongs_to :escalation
end
