class Notifier
  include Mongoid::Document
  field :notify_after, type: Integer
  field :type, type: String
  field :details, type: Hash

  belongs_to :user

  validates :notify_after, presence: true
  validates :type, presence: true
  validates :type, inclusion: {in: %w!mail!}
  validates :user, presence: true

  def notify(incident)
    p incident
  end
end
