class Escalation < ActiveRecord::Base
  validates :escalate_to, presence: true
  validates :escalation_rule, presence: true
  validates :escalate_after, presence: true
  validates_each :escalate_to do |record, attr, value|
    unless [User, Shift].find {|klass| value.is_a?(klass) }
      record.errors.add(attr, 'must be User or Shift')
    end
  end

  belongs_to :escalate_to, polymorphic: true
  belongs_to :escalation_rule

  def user_escalate_to
    user = nil

    case escalate_to
    when User
      user = escalate_to
    when Shift
      user = escalate_to.current_user
      unless user
        Rails.debug "The shift doesn't have user to be escalated to."
      end
    end

    user
  end
end
