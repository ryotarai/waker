class Escalation < ApplicationRecord
  belongs_to :escalation_series
  belongs_to :escalate_to, class_name: 'User'

  validates :escalation_series, presence: true
  validates :escalate_to, presence: true
  validates :escalate_after_sec, numericality: {greater_than_or_equal_to: 5}
end
