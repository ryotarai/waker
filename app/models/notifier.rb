class Notifier < ActiveRecord::Base
  include JsonField

  json_field :details

  belongs_to :user

  validates :name, presence: true
  validates :notify_after, presence: true
  validates :kind, presence: true
  validates :kind, inclusion: {in: %w!mail!}
  validates :user, presence: true

  after_initialize :set_defaults

  def set_defaults
    self.details ||= {}
  end

  def notify(incident)
    case self.kind
    when 'mail'
      NotifierMailer.incident(self, incident).deliver
    end
  end
end
