class Topic < ActiveRecord::Base
  enum kind: [:api]
  belongs_to :escalation_series
  has_many :incidents

  validates :name, presence: true
  validates :kind, presence: true
  validates :escalation_series, presence: true

  def in_maintenance?(*bodies)
    maints = Maintenance.active.where(topic: self)
    maints.any? do |m|
      if m.filter.blank?
        true
      else
        r = m.filter_regexp
        bodies.any? do |body|
          !!r.match(body)
        end
      end
    end
  end
end
