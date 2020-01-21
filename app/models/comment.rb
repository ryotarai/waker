class Comment < ApplicationRecord
  belongs_to :incident
  belongs_to :user

  validates :incident, presence: true
  validates :user, presence: true
  validates :comment, presence: true
end
