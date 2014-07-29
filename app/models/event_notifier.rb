class EventNotifier < ActiveRecord::Base
  include JsonField

  json_field :details

  validates :kind, presence: true
  validates :kind, inclusion: {in: %w!hipchat!}

  after_initialize :set_defaults

  def set_defaults
    self.details ||= {}
  end

  def self.fire(type, details)
    self.all.each do |event_notifier|
      event_notifier.notify(type, details)
    end
  end

  def notify(type, details)
    notifier_class.new(self).notify(type, details)
  end

  def notifier_class
    EventNotifier.const_get("#{self.kind.capitalize}Notifier")
  end

  class BaseNotifier
    def initialize(event_notifier)
      @event_notifier = event_notifier
    end

    def notify(type, details)
      raise NotImplementedError
    end
  end

  class HipchatNotifier
    def notify(type, details)
      send(type, details)
    end

    private
    def api_token
      ENV['HIPCHAT_TOKEN']
    end

    def room
      event_notifier.details.fetch('room')
    end

    def username
      'Waker'
    end

    def client
      HipChat::Client.new(api_token, api_version: 'v2')
    end

    def send_message(*args)
      client[room].send(username, *args)
    end

    # events
    def incident_opened(details)
      incident = details[:incident]
      send_message(<<-EOC, color: :red)
New incident opened: #{incident.description} (<a href="#{acknowledge_api_incident_url(incident, hash: incident.check_hash)}">Acknowledge</a>) (<a href="#{resolve_api_incident_url(incident, hash: incident.check_hash)}">Resolve</a>)
      EOC
    end

    def incident_acknowledged(details)
      incident = details[:incident]
      send_message(<<-EOC, color: :yellow)
Incident acknowledged: #{incident.description}
      EOC
    end

    def incident_resolved(details)
      incident = details[:incident]
      send_message(<<-EOC, color: :green)
Incident resolved: #{incident.description}
      EOC
    end

    def incident_escalated(details)
      incident = details[:incident]
      escalate_to = details[:escalate_to]
      send_message(<<-EOC, color: :yellow)
Incident escalated to #{escalate_to.name}: #{incident.description}
      EOC
    end
  end
end
