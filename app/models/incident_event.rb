class IncidentEvent < ActiveRecord::Base
  KINDS = [:open, :acknowledge, :resolve, :escalate, :comment]

  belongs_to :incident
  belongs_to :user_by, class: User

  enum kind: KINDS

  validates :incident, presence: true
  validates :kind, presence: true
  validates :text, presence: true
end
