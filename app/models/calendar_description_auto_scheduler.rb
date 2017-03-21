class CalendarDescriptionAutoScheduler < AutoScheduler
  class << self
    def public_holiday?(day)
      HolidayJp.holiday?(day)
    end

    def weekend?(day)
      day.saturday? || day.sunday?
    end

    def holiday?(day)
      public_holiday?(day) || weekend?(day)
    end

    def weekday?(day)
      !holiday?(day)
    end
  end

  def initialize(*)
    super
    require 'google/api_client'
  end

  def update!
    client = Google::APIClient.new(application_name: "Waker", application_version: "2.0.0")

    auth = client.authorization

    expired = Time.at(user_as.credentials.fetch('expires_at')) < Time.now
    if user_as.credentials.fetch('expires') && expired
      Rails.logger.info "Refreshing access token"

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

    event_list = Hash.new {|h,k| h[k] = [] }

    client.execute(
      api_method: calendar_api.events.list,
      parameters: {
        'calendarId' => calendar['id'],
        'timeMin' => Time.now.iso8601,
        'timeMax' => Time.now.next_month.iso8601,
      }
    ).data.items.sort do |a, b|
      a.start.dateTime <=> b.start.dateTime
    end.each do |event|
      description = schedule_description(event)
      event_list[description['tag']].push(event) if description
    end

    if event_list.count < 1
      Rails.logger.error "event list is empty."
      return
    end

    event_list.each do |_, v|
      description = schedule_description(v.first)
      kimeruhi = (Date.today..Date.today.next_month).reject do |day|
        description['conditions'].none? do |condition|
          case condition
          when 'holiday', 'weekday', 'weekend'
            CalendarDescriptionAutoScheduler::send("#{condition}?", day)
          else
            day.send("#{condition}?")
          end
        end
      end

      if kimeruhi.count < 1
        Rails.logger.error "kimeruhi is empty."
        return
      end

      order = v.last.summary.split(event_delimiter)

      kimeruhi.each do |target|
        if target <= v.last.start.dateTime
          next
        end

        if description['target']
          order.rolling!(description['target']['start'] - 1, description['target']['end'] - 1)
        else
          order.rolling!()
        end
        start = target.since(v.last.start.dateTime.seconds_since_midnight)
        client.execute(
          api_method: calendar_api.events.insert,
          parameters: {
            calendarId: calendar['id']
          },
          body_object: {
            summary: order.join(event_delimiter),
            start: {
              dateTime: start.iso8601
            },
            end: {
              dateTime: (start + (v.last.end.dateTime - v.last.start.dateTime)).iso8601
            },
            description: v.last.description
          }
        )
      end
    end
  end

  def schedule_description(event)
    event['description'] ? YAML.load(event['description']) : nil
  end
end
