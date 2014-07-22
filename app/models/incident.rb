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
#  after_create :trigger_incident
#
  def set_defaults
    self.details ||= {}
  end
#
#  def trigger_incident
#    escalation = self.provider.escalation
#    current_time = Time.now
#    escalation.decoded_rules.each do |rule|
#      EscalationQueue.create!(
#        assignee: rule['target'],
#        incident: self,
#        escalate_at: current_time + rule['at'],
#      )
#    end
#  end
end
