class Incident < ActiveRecord::Base
  include JsonField

  json_field :details

  belongs_to :provider
#  has_and_belongs_to_many :assignees, class_name: 'User'
#
#  validates :description, presence: true
#  validates :provider, presence: true
#
#  as_enum :status, open: 0, acknowledged: 1, resolved: 2
#
  after_initialize :set_defaults
  after_create :trigger_incident

  def set_defaults
    self.details ||= {}
  end

  def trigger_incident
    escalation_rule = self.provider.escalation_rule
    current_time = Time.now
    escalation_rule.escalations.each do |escalation|
      EscalationQueue.create!(
        incident: self,
        escalation: escalation,
        escalate_at: current_time + escalation.escalate_after,
      )
    end
  end
end
