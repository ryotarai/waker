require 'securerandom'

class User < ActiveRecord::Base
  has_many :notifiers

  validates :name, presence: true
  validates :email, presence: true

  before_save :set_defaults

  def self.find_from_auth_hash(auth_hash)
    self.find_by(email: auth_hash[:info][:email])
  end

  def token_expired?
    self.token_expires_at < Time.now
  end

  private

  def set_defaults
    self.login_token ||= SecureRandom.hex
  end
end
