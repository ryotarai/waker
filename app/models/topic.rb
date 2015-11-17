class Topic < ActiveRecord::Base
  enum kind: [:api]
  belongs_to :escalation_series
  has_many :incidents

  validates :name, presence: true
  validates :kind, presence: true
  validates :escalation_series, presence: true
end
