require 'securerandom'

class User < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  has_many :notifiers

  serialize :credentials, JSON

  validates :name, presence: true

  before_save :set_defaults

  def self.find_or_create_from_auth_hash(auth_hash)
    user = self.find_by(provider: auth_hash[:provider], uid: auth_hash[:uid])
    return user if user

    user = self.find_by(email: auth_hash[:info][:email])
    if user
      # email is deprecated
      user.update!(provider: auth_hash[:provider], uid: auth_hash[:uid], email: nil)
      return user
    end

    self.create!(provider: auth_hash[:provider], uid: auth_hash[:uid], name: auth_hash[:info][:name])
  end

  def update_credentials_from_auth_hash(auth_hash)
    self.update!(credentials: auth_hash.fetch(:credentials))
  end

  private

  def set_defaults
    self.login_token ||= SecureRandom.hex
  end
end
