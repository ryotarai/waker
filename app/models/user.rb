class User < ActiveRecord::Base
  has_many :notifiers

  validates :name, presence: true
end
