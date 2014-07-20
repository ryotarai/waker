class Provider
  include Mongoid::Document
  field :type, type: String
  field :details, type: Hash
end
