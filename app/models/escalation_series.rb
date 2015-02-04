class EscalationSeries < ActiveRecord::Base
  has_many :escalations
  has_many :topics

  serialize :settings, JSON
  after_initialize :set_defaults

  def set_defaults
    self.settings ||= {}
  end

  def update_escalations!
    updater_class = case self['update_by']
                    when 'google_calendar'
                      GoogleCalendarEscalationUpdater
                    else
                      # do nothing
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
    def update!
      client = Google::APIClient.new

      if user_as.token_expired?
        client.authorization.refresh_token = user_as.refresh_token
        client.authorization.refresh!

        user_as.update!(token: client.authorization.access_token)
      else
        client.authorization.access_token = user_as.token
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

