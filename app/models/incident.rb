class Incident
  include Mongoid::Document
  field :description, type: String
  field :details, type: Hash
  belongs_to :provider

  validates :description, presence: true
  validates :details, presence: true
  validates :provider, presence: true
end
