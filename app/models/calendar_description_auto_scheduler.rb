class CalendarDescriptionAutoScheduler < AutoScheduler
  class << self
    def public_holiday
      @@public_holiday ? @@public_holiday : @@public_holiday = HolidayJp.between(Date.today, Date.today.next_month).map { |day| day.date }
    end

    def holiday
      @@holiday ? @@holiday : @@holiday = weekend.concat(public_holiday).sort
    end

    def weekend
      @@weekend ? @@weekend : @@weekend = (Date.today..Date.today.next_month).select{ |day| day.saturday? || day.sunday? }
    end

    def weekday
      @@weekday ? @@weekday : @@weekday = (Date.today..Date.today.next_month).to_a - holiday
    end

    def date_set
      @@date_set ? @@data_set : @@data_set = {
        'public_holiday' => public_holiday,
        'weekend' => weekend,
        'holiday' => holiday
      }
    end

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
  @@public_holiday = nil
  @@weekend = nil
  @@holiday = nil
  @@date_set = nil
  @@weekday = nil

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
      pp description['conditions']
      pp kimeruhi
    end
  end

  def tes
    self.send("holiday?", Date.today)
  end

  def term
    @series.settigns['term'] || '1month'
  end

  def range
    @series.settings['range'] || {start => 1, :end => @series.escalations.count}
  end

  def schedule_description(event)
    event['description'] ? YAML.load(event['description']) : nil
  end

end
