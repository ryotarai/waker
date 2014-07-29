require 'icalendar'
require 'open-uri'

class Shift < ActiveRecord::Base
  validates :name, presence: true

  def fetch_calendars
    return nil unless self.ical
    Icalendar.parse(open(self.ical))
  end

  def user_at(time)
    calendars = fetch_calendars
    user = nil

    if calendars
      events = calendars.map do |cal|
        cal.events.select do |e|
          e.dtstart.to_datetime <= time &&
            time <= e.dtend.to_datetime
        end
      end.flatten

      events.sort! do |a, b|
        a.dtend.to_datetime - a.dtstart.to_datetime <=>
        b.dtend.to_datetime - b.dtstart.to_datetime
      end

      event = events.first # shortest

      if event
        summary = event.summary.to_s
        user_names = summary.split('->').map do |str|
          str.strip
        end
        user_name = user_names[self.index || 0]
        return nil unless user_name

        user = User.find_by(name: user_name)
        return user if user
      end
    end

    nil
  end

  def current_user
    user_at(Time.now)
  end
end
