class Provider
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :details, type: Hash
  has_many :incidents

  validates :type, presence: true
  validates :type, inclusion: {in: %w!api!}
  validates :escalation, presence: true

  belongs_to :escalation
end
