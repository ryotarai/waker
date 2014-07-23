class Provider < ActiveRecord::Base
  include JsonField

  json_field :details

  has_many :incidents

  validates :name, presence: true
  validates :kind, presence: true
  validates :kind, inclusion: {in: %w!api!}
  validates :escalation_rule, presence: true

  belongs_to :escalation_rule
  
  after_initialize :set_defaults

  def set_defaults
    self.details ||= {}
  end
end
