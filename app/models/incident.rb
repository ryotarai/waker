class Incident < ActiveRecord::Base
  STATUSES = [:opened, :acknowledged, :resolved]

  belongs_to :topic
  has_many :events, class: IncidentEvent
  enum status: STATUSES
  
  validates :topic, presence: true
  validates :subject, presence: true
  validates :description, presence: true
  validates :occured_at, presence: true

  before_save :set_defaults
  after_create :enqueue

  def acknowledge!
    return if self.acknowledged? || self.resolved?

    self.acknowledged!
    self.save!

    events.create(kind: :acknowledge)
  end

  def resolve!
    return if self.resolved?

    self.resolved!
    self.save!

    events.create(kind: :resolve)
  end

  private
  def set_defaults
    self.status ||= :opened
  end

  def enqueue
    topic.escalation_series.escalations.each do |escalation|
      EscalationWorker.enqueue(self, escalation)
    end

    events.create(kind: :open)
  end
end

