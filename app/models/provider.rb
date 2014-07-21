class Provider
  include Mongoid::Document
  field :type, type: String
  field :details, type: Hash
  has_many :incidents
end
