class EscalationSeries < ActiveRecord::Base
  has_many :escalations
  has_many :topics
end
