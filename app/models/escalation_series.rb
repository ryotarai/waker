class EscalationSeries < ApplicationRecord
  has_many :escalations, dependent: :destroy
  has_many :topics, dependent: :destroy

  validates :name, presence: true

  serialize :settings, JSON
  after_initialize :set_defaults

  def set_defaults
    self.settings ||= {}
  end

  def update_escalations!
    updater_class = case self.settings['update_by']
                    when 'google_calendar'
                      GoogleCalendarEscalationUpdater
                    else
                      nil
                    end
    if updater_class
      updater = updater_class.new(self)
      updater.update!
    end
  end

  class EscalationUpdater
    def initialize(series)
      @series = series
    end

    def update!
      raise NotImplementedError
    end

    private

    def settings
      @series.settings
    end
  end

  class GoogleCalendarEscalationUpdater < EscalationUpdater
    def initialize(*)
      super
      require 'google/api_client'
    end

    def update!
      Rails.logger.info "Update #{@series.inspect} by Google Calendar"

      if user_as.provider && user_as.provider != 'google_oauth2_with_calendar'
        raise "User ##{user_as.id} is not authenticated by 'google_oauth2_with_calendar' provider"
      end

      client = Google::APIClient.new(application_name: "Waker", application_version: "2.0.0")
      auth = client.authorization

      expired = Time.at(user_as.credentials.fetch('expires_at')) < Time.now
      if user_as.credentials.fetch('expires') && expired
        Rails.logger.info "Refreshing access token..."

        auth.client_id = ENV["GOOGLE_CLIENT_ID"]
        auth.client_secret = ENV["GOOGLE_CLIENT_SECRET"]
        auth.refresh_token = user_as.credentials.fetch('refresh_token')
        auth.grant_type = "refresh_token"
        auth.refresh!

        user_as.update!(
          credentials: user_as.credentials.merge(
            'token' => auth.access_token,
            'expires_at' => auth.expires_at.to_i,
          )
        )
      else
        auth.access_token = user_as.credentials.fetch('token')
      end

      calendar_api = client.discovered_api('calendar', 'v3')

      calendar = client.execute(
        api_method: calendar_api.calendar_list.list,
        parameters: {},
      ).data.items.find do |cal|
        cal['summary'] == calendar_name
      end

      events = client.execute(
        api_method: calendar_api.events.list,
        parameters: {
          'calendarId' => calendar['id'],
          'timeMax' => (Time.now + 1).iso8601,
          'timeMin' => (Time.now).iso8601,
          'singleEvents' => true,
        },
      ).data.items

      events.each do |event|
        unless event['end']['dateTime'] && event['start']['dateTime']
          raise "dateTime field is not found (The event may be all-day event)\n#{event}"
        end
      end

      events.sort! do |a, b|
        a['end']['dateTime'] - a['start']['dateTime'] <=>
          b['end']['dateTime'] - b['start']['dateTime']
      end

      # shortest event
      event = events.first

      persons = event['summary'].split(event_delimiter).map(&:strip)
      escalations = @series.escalations.order('escalate_after_sec')

      persons.each_with_index do |name, i|
        user = User.find_by(name: name)
        raise "User '#{name}' is not found." unless user
        escalation = escalations[i]
        escalation.update!(escalate_to: user)
      end
    end

    private

    def user_as
      User.find(settings.fetch('user_as_id'))
    end

    def calendar_name
      settings.fetch('calendar')
    end

    def event_delimiter
      settings.fetch('event_delimiter')
    end
  end
end
