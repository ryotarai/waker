require 'digest/sha1'

class Incident < ActiveRecord::Base
  STATUSES = [:opened, :acknowledged, :resolved]

  belongs_to :topic
  has_many :events, class_name: 'IncidentEvent', dependent: :destroy
  enum status: STATUSES
  has_many :comments

  validates :topic, presence: true
  validates :subject, presence: true
  validates :description, presence: true
  validates :occured_at, presence: true

  after_initialize :set_defaults
  after_create :enqueue

  def acknowledge!
    return if self.acknowledged? || self.resolved?

    self.acknowledged!

    events.create(kind: :acknowledged)
  end

  def resolve!
    return if self.resolved?

    self.resolved!

    events.create(kind: :resolved)
  end

  def confirmation_hash
    Digest::SHA1.hexdigest("#{Rails.application.secrets.secret_key_base}#{self.id}")
  end

  private

  def set_defaults
    self.status ||= :opened
    self.occured_at ||= Time.now
  end

  def enqueue
    topic.escalation_series.escalations.each do |escalation|
      EscalationWorker.enqueue(self, escalation)
    end

    events.create(kind: :opened)
  end
end
