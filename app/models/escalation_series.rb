class EscalationSeries < ActiveRecord::Base
  has_many :escalations
  has_many :topics

  serialize :settings, JSON
  after_initialize :set_defaults

  def set_defaults
    self.settings ||= {}
  end

  def update_by
    self.settings['update_by']
  end

  def user_as
    if user_as_id = self.settings['user_as_id']
      User.find(user_as_id)
    end
  end

  def update_escalations
    case update_by
    when 'google_calendar'
      update_by_google_calendar
    end
  end

  def update_by_google_calendar
    client = Google::APIClient.new
    client.authorization.access_token = user_as.token

    calendar_api = client.discovered_api('calendar', 'v3')

    calendar = client.execute(
      api_method: calendar_api.calendar_list.list,
      parameters: {},
    ).data.items.find do |cal|
      cal['summary'] == self.settings.fetch('calendar')
    end

    events = client.execute(
      api_method: calendar_api.events.list,
      parameters: {
        'calendarId' => calendar['id'],
        'timeMax' => (Time.now + 1).strftime('%FT%T%:z'),
        'timeMin' => (Time.now).strftime('%FT%T%:z'),
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

    persons = event['summary'].split(settings.fetch('delimiter')).map(&:strip)
    escalations = self.escalations.order('escalate_after_sec')

    persons.each_with_index do |name, i|
      user = self.users.find_by(name: name)
      escalation = escalations[i]
      escalation.update!(escalate_to: user)
    end
  end
end
