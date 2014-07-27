class Notifier < ActiveRecord::Base
  include JsonField

  json_field :details

  belongs_to :user

  validates :name, presence: true
  validates :notify_after, presence: true
  validates :kind, presence: true
  validates :kind, inclusion: {in: %w!mail phone!}
  validates :user, presence: true

  after_initialize :set_defaults

  def set_defaults
    self.details ||= {}
  end

  def notify(incident)
    klass = Notifier.const_get("#{self.kind.capitalize}Notifier")
    notifier = klass.new(self, incident)
    notifier.notify
  end

  class BaseNotifier
    def initialize(notifier, incident)
      @notifier = notifier
      @incident = incident
    end

    def notify
      raise NotImplementedError
    end
  end

  class MailNotifier < BaseNotifier
    def notify
      NotifierMailer.incident(@notifier, @incident).deliver
    end
  end

  require 'twilio-ruby'
  class PhoneNotifier < BaseNotifier
    def notify
      client.account.calls.create(
        :from => from_number,
        :to => to_number,
        :url => 'http://demo.twilio.com/welcome/voice/',
      )
    end

    private
    def client
      @client ||= Twilio::REST::Client.new(account_sid, auth_token)
    end

    def account_sid
      ENV['TWILIO_ACCOUNT_SID']
    end

    def auth_token
      ENV['TWILIO_AUTH_TOKEN']
    end

    def from_number
      ENV['TWILIO_FROM_NUMBER']
    end

    def to_number
      @notifier.details['to']
    end
  end
end
