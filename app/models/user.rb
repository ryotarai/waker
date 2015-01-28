class User < ActiveRecord::Base
  has_many :notifiers

  validates :name, presence: true
  validates :email, presence: true

  def self.find_from_auth_hash(auth_hash)
    self.find_by(email: auth_hash[:info][:email])
  end
end
