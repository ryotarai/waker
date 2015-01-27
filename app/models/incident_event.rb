class IncidentEvent < ActiveRecord::Base
  KINDS = [:opened, :acknowledged, :resolved, :escalated, :commented]

  belongs_to :incident

  enum kind: KINDS

  validates :incident, presence: true
  validates :kind, presence: true

  serialize :info, JSON
  after_create :notify
  after_initialize :set_defaults

  def set_defaults
    self.info ||= {}
  end

  def notify
    Notifier.all.each do |notifier|
      notifier.notify(self)
    end
  end

  def escalated_to
    self.info['escalated_to'] && User.find(self.info['escalated_to']['id'])
  end

  def escalation
    self.info['escalation'] && Escalation.find(self.info['escalation']['id'])
  end
end
