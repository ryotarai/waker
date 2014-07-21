class User
  include Mongoid::Document
  field :name, type: String

  validates :name, presence: true
end
