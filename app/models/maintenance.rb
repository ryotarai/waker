class Maintenance < ApplicationRecord
  scope :active, -> { t = Time.now; where('start_time <= ? AND ? <= end_time', t, t) }
  scope :not_expired, -> { where('? <= end_time', Time.now) }
  scope :expired,     -> { where('end_time < ?', Time.now) }

  belongs_to :topic

  def filter_regexp
    Regexp.new(filter)
  end
end
