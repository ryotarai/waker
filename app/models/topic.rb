class Topic < ActiveRecord::Base
  enum kind: [:api]
  belongs_to :escalation_series
  has_many :incidents

  validates :name, presence: true
  validates :kind, presence: true
  validates :escalation_series, presence: true

  def in_maintenance?
    !(Maintenance.active.where(topic: self).empty?)
  end
end
