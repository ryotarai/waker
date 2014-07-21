class Incident
  include Mongoid::Document
  field :description, type: String
  field :details, type: Hash
  belongs_to :provider
end
