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
      calendars.each do |cal|
        event = cal.events.find do |e|
          e.dtstart.to_datetime <= time &&
            time <= e.dtend.to_datetime
        end
        next unless event

        user = User.find_by(name: event.summary.to_s)
        break if user
      end

      return user if user
    end

    nil
  end

  def current_user
    user_at(Time.now)
  end
end
