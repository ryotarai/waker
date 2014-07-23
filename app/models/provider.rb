class Provider < ActiveRecord::Base
  include JsonField

  json_field :details
#  include Mongoid::Document
#  field :name, type: String
#  field :type, type: String
#  field :details, type: Hash
#  has_many :incidents
#
  validates :name, presence: true
  validates :kind, presence: true
#  validates :type, inclusion: {in: %w!api!}
  validates :escalation_rule, presence: true
#
  belongs_to :escalation_rule
  
  after_initialize :set_defaults

  def set_defaults
    self.details ||= {}
  end
end
