class Notifier < ActiveRecord::Base
  include JsonField

  json_field :details
  json_field :ignore_periods

  belongs_to :user

  validates :name, presence: true
  validates :notify_after, presence: true
  validates :kind, presence: true
  validates :kind, inclusion: {in: %w!mail phone!}
  validates :user, presence: true

  after_initialize :set_defaults

  def set_defaults
    self.details ||= {}
    self.ignore_periods ||= []
  end

  def notify(incident)
    return if self.ignored?
    klass = Notifier.const_get("#{self.kind.capitalize}Notifier")
    notifier = klass.new(self, incident)
    notifier.notify
  end

  def ignored?
    self.ignore_periods.any? do |period|
      # period = {'start' => '9:30', 'end' => '18:30', 'not_holiday_jp' => true}
      start_time = Time.parse(period['start'])
      end_time = Time.parse(period['end'])

      today = Date.today
      holiday = HolidayJp.holiday?(today) || today.saturday? || today.sunday?
      if period['not_holiday_jp']
        next false if holiday
      end

      if period['holiday_jp']
        next false unless holiday
      end

      start_time <= Time.now && Time.now <= end_time
    end
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

  class PhoneNotifier < BaseNotifier
    def notify
      url = Rails.application.routes.url_helpers.twilio_api_incident_url(@incident, user: ENV['TWILIO_BASIC_AUTH_USER'], password: ENV['TWILIO_BASIC_AUTH_PASSWORD'])
      client.account.calls.create(
        :from => from_number,
        :to => to_number,
        :url => url,
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
