class User < ActiveRecord::Base
#  include Mongoid::Document
#  field :name, type: String
#
#  has_and_belongs_to_many :incidents
  has_many :notifiers

  validates :name, presence: true
end
