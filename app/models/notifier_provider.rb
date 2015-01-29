class NotifierProvider < ActiveRecord::Base
  KINDS = [:mailgun, :file, :rails_logger, :hipchat, :twilio]
  serialize :settings, JSON
  enum kind: KINDS

  after_initialize :set_defaults

  def set_defaults
    self.settings ||= {}
  end

  def concrete_class
    self.class.const_get("#{kind.to_s.split('_').map(&:capitalize).join}ConcreteProvider")
  end

  def notify(event:, notifier:)
    concrete_class.new(provider: self, notifier: notifier, event: event).notify
  end

  class ConcreteProvider
    def initialize(provider:, notifier:, event:)
      @provider = provider
      @notifier = notifier
      @event = event
    end

    def notify
      if reason = skip_reason
        Rails.logger.info "Notification skipped due to '#{reason}'"
      else
        if target_events.include?(kind_of_event)
          _notify
        else
          Rails.logger.info "Notification skipped due to target events (#{target_events} doesn't include #{kind_of_event})"
        end
      end
    end

    def _notify
      raise NotImplementedError
    end

    def settings
      @provider.settings.merge(@notifier.settings)
    end

    def skip_reason
      if settings['only_japanese_weekday']
        if HolidayJp.holiday?(Date.today)
          return 'only_japanese_weekday'
        end
      end

      if between = settings['between']
        start_time, end_time = between.split('-')
        start_time = Time.parse(start_time)
        end_time   = Time.parse(end_time)
        unless start_time < Time.now && Time.now < end_time
          return 'between'
        end
      end

      return nil
    end

    def all_events
      [:escalated, :escalated_to_me, :opened, :acknowledged, :resolved, :commented]
    end

    def target_events
      settings['events'] &&
        settings['events'].map {|v| v.to_sym }
    end

    def body
      template_names = [kind_of_event, 'default']
      template_names.each_with_index do |template_name, i|
        begin
          rendered = ApplicationController.new.render_to_string(
            template: "notifier_providers/#{@provider.kind}/#{template_name}",
            locals: {event: @event},
          )

          return rendered
        rescue ActionView::MissingTemplate
          raise if template_names.size - 1 == i
        end
      end
    end

    def kind_of_event
      if @event.escalated? && @event.escalated_to == @notifier.user
        :escalated_to_me
      else
        @event.kind.to_sym
      end
    end
  end

  class FileConcreteProvider < ConcreteProvider
    def _notify
    end
  end

  class RailsLoggerConcreteProvider < ConcreteProvider
    def _notify
      Rails.logger.info(body)
    end

    def target_events
      all_events
    end
  end

  class HipchatConcreteProvider < ConcreteProvider
    def _notify
      case event
      when :opened
        color = 'red'
      when :acknowledged, :escalated
        color = 'yellow'
      when :resolved
        color = 'green'
      else
        return
      end

      client = HipChat::Client.new(api_token)
      client[room].send('Waker', body, color: color)
    end

    private
    
    def api_token
      settings.fetch('api_token')
    end

    def room
      settings.fetch('room')
    end

    def target_events
      super || [:escalated, :opened, :acknowledged, :resolved]
    end
  end

  class MailgunConcreteProvider < ConcreteProvider
    def _notify
      conn = Faraday.new(url: 'https://api.mailgun.net') do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
      end

      conn.basic_auth('api', api_key)

      response = conn.post "/v2/#{domain}/messages", {
        from: from,
        to: to,
        subject: "[Waker] #{incident.subject}",
        text: body,
      }

      Rails.logger.info "response status: #{response.status}"
      Rails.logger.info JSON.parse(response.body)
    end

    private
    def api_key
      settings.fetch('api_key')
    end

    def domain
      from.split('@').last
    end

    def from
      settings.fetch('from')
    end

    def to
      settings.fetch('to')
    end

    def target_events
      super || [:escalated_to_me]
    end
  end

  class TwilioConcreteProvider < ConcreteProvider
    def _notify
      options = {}
      options[:user] =     basic_auth_user if basic_auth_user
      options[:password] = basic_auth_password if basic_auth_password

      url = Rails.application.routes.url_helpers.twilio_incident_event_url(
        @event, options
      )

      Twilio::REST::Client.new(account_sid, auth_token).account.calls.create(
        from: from,
        to: to,
        url: url,
      )
    end

    def account_sid
      settings.fetch('account_sid')
    end

    def auth_token
      settings.fetch('auth_token')
    end

    def from
      settings.fetch('from')
    end

    def from
      settings.fetch('to')
    end

    def target_events
      super || [:escalated_to_me]
    end

    def basic_auth_user
      ENV['BASIC_AUTH_USER']
    end

    def basic_auth_password
      ENV['BASIC_AUTH_PASSWORD']
    end
  end
end


