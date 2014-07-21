class Provider
  include Mongoid::Document
  field :type, type: String
  field :details, type: Hash
  has_many :incidents

  validates :type, presence: true
  validates :details, presence: true

  validates :type, inclusion: {in: %w!api!}
end
