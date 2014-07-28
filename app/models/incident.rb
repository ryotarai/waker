require 'securerandom'

class Incident < ActiveRecord::Base
  class Error < StandardError; end

  include JsonField

  json_field :details

  enum status: %i!opened acknowledged resolved!
  belongs_to :provider

  validates :description, presence: true
  validates :provider, presence: true

  after_initialize :set_defaults
  after_create :trigger_incident

  def set_defaults
    self.details ||= {}
    self.status ||= :opened
    self.check_hash ||= SecureRandom.hex
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

  def acknowledge
    if self.acknowledged? || self.resolved?
      raise Error, "The incident is already #{self.status}."
    end
    self.acknowledged!
  end

  def resolve
    if self.resolved?
      raise Error, "The incident is already #{self.status}."
    end
    self.resolved!
  end
end
