class Topic < ActiveRecord::Base
  KINDS = [:api]

  enum kind: KINDS
  belongs_to :escalation_series
  has_many :incidents

  validates :name, presence: true
  validates :kind, presence: true
  validates :escalation_series, presence: true
end
