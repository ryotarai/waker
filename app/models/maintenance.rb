class Maintenance < ActiveRecord::Base
  scope :not_expired, -> { where('end_time >= ?', Time.now) }
  scope :expired, -> { where('end_time < ?', Time.now) }
  belongs_to :topic
end
