require 'icalendar'
require 'open-uri'
require 'json'

class Shift < ActiveRecord::Base
  validates :name, presence: true

  def current_user
    if self.ical
      current_user_from_ical
    elsif self.json_file
      current_user_from_json_file
    end
  end

  private
  def current_user_from_ical
    time = Time.now
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

  def current_user_from_json_file
    names = JSON.parse(File.read(self.json_file))
    User.find_by(name: names[self.index])
  end

  def fetch_calendars
    return nil unless self.ical
    Icalendar.parse(open(self.ical))
  end

end
