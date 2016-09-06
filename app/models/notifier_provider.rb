class NotifierProvider < ActiveRecord::Base
  serialize :settings, JSON
  enum kind: [:mailgun, :file, :rails_logger, :hipchat, :twilio, :slack, :datadog, :sns]

  validates :name, presence: true

  after_initialize :set_defaults

  def set_defaults
    self.settings ||= {}
  end

  def concrete_class
    self.class.const_get("#{kind.to_s.camelize}ConcreteProvider")
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
      if skip?
        Rails.logger.info "Notification skipped."
      else
        if target_events.include?(kind_of_event)
          _notify
          @event.incident.events.create(
            kind: :notified,
            info: {notifier: @notifier, event: @event}
          )
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

    def skip?
      # or_conditions = [
      #   {
      #     'only_japanese_weekday' => true,
      #     'not_between' => '9:30-18:30',
      #   },
      #   {
      #     'not_japanese_weekday' => true,
      #   }
      # ]
      return skip_due_to_or_conditions? ||
        skip_due_to_status_of_incident?
    end

    def skip_due_to_status_of_incident?
      if !@event.incident.opened? && !([:acknowledged, :resolved].include?(kind_of_event))
        return true
      end

      false
    end

    def skip_due_to_or_conditions?
      or_conditions = settings['or_conditions']
      return false unless or_conditions

      matched = or_conditions.any? do |condition|
        # japanese_weekday
        holiday = HolidayJp.holiday?(Date.today) || Time.now.saturday? || Time.now.sunday?

        if holiday && condition['japanese_weekday']
          next false
        end

        if !holiday && condition['not_japanese_weekday']
          next false
        end

        # between
        skip_due_to_between_condition = %w!between not_between!.any? do |k|
          if s = condition[k]
            start_time, end_time = s.split('-')
            start_time = Time.parse(start_time)
            end_time   = Time.parse(end_time)
            between = start_time < Time.now && Time.now < end_time
            if (between && k == 'not_between') || (!between && k == 'between')
              next true
            end
          end

          false
        end

        next false if skip_due_to_between_condition

        true
      end

      return !matched
    end

    def all_events
      [:escalated, :escalated_to_me, :opened, :acknowledged, :resolved, :commented]
    end

    def target_events
      settings['events'] &&
        settings['events'].map {|v| v.to_sym }
    end

    def body(formats: [:text])
      template_names = [kind_of_event, 'default']
      template_names.each_with_index do |template_name, i|
        begin
          rendered = ApplicationController.new.render_to_string(
            template: "notifier_providers/#{@provider.kind}/#{template_name}",
            formats: formats,
            layout: nil,
            locals: {event: @event},
          )

          return rendered.strip
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
      case kind_of_event
      when :opened
        color = 'red'
      when :acknowledged, :escalated
        color = 'yellow'
      when :resolved
        color = 'green'
      else
        return
      end

      client = HipChat::Client.new(api_token, api_version: api_version)
      client[room].send('Waker', body, color: color, notify: notify?)
    end

    private

    def api_token
      settings.fetch('api_token')
    end

    def room
      settings.fetch('room')
    end

    def api_version
      case settings.fetch('api_version')
      when '2', 'v2'
        'v2'
      when '1', 'v1'
        'v1'
      else
        'v2'
      end
    end

    def notify?
      !!settings['notify']
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
        subject: "[Waker] #{@event.incident.subject}",
        text: body,
        html: body(formats: [:html]),
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

    def to
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

  class SlackConcreteProvider < ConcreteProvider
    def _notify
      fields = []

      acknowledge_url = Rails.application.routes.url_helpers.acknowledge_incident_url(@event.incident, hash: @event.incident.confirmation_hash)
      resolve_url = Rails.application.routes.url_helpers.resolve_incident_url(@event.incident, hash: @event.incident.confirmation_hash)

      case kind_of_event
      when :opened
        color = 'danger'
        title = 'New incident opened'
        action_links = "<#{acknowledge_url}|Acknowledge> or <#{resolve_url}|Resolve>"
      when :acknowledged
        color = 'warning'
        title = 'Incident acknowledged'
        action_links = "<#{resolve_url}|Resolve>"
      when :escalated
        color = 'warning'
        title = "Incident escalated to #{@event.escalated_to.name}"
        action_links = "<#{acknowledge_url}|Acknowledge> or <#{resolve_url}|Resolve>"
      when :resolved
        color = 'good'
        title = 'Incident resolved'
        action_links = nil
      end

      text = @event.incident.subject
      if action_links
        text += " (#{action_links})"
      end

      attachments = [{
        "fallback" => "[#{kind_of_event.to_s.capitalize}] #{@event.incident.subject}",
        "color" => color,
        "title" => title,
        "text" => text,
        "fields" => fields,
      }]

      payload = {'attachments' => attachments}
      if channel
        payload['channel'] = channel
      end

      url = URI.parse(webhook_url)
      conn = Faraday.new(:url => "#{url.scheme}://#{url.host}") do |faraday|
        faraday.adapter Faraday.default_adapter
      end

      conn.post do |req|
        req.url url.path
        req.headers['Content-Type'] = 'application/json'
        req.body = payload.to_json
      end
    end

    private

    def webhook_url
      settings.fetch('webhook_url')
    end

    def channel
      settings['channel']
    end

    def target_events
      [:escalated, :opened, :acknowledged, :resolved]
    end
  end

  class DatadogConcreteProvider < ConcreteProvider
    def _notify
      dog = Dogapi::Client.new(api_key, app_key)

      res = dog.emit_event(Dogapi::Event.new(
              @event.incident.description, {
                msg_title: @event.incident.subject,
                alert_type: alert_type,
                tags: tags,
                source_type_name: source_type_name,
              }
            ))

      Rails.logger.info res
    end

    private

    def api_key
      settings.fetch('api_key')
    end

    def app_key
      settings.fetch('app_key')
    end

    def alert_type
      settings['alert_type'] || 'error'
    end

    def tags
      settings['tags'] || 'waker'
    end

    def source_type_name
      settings['source_type_name'] || 'waker'
    end

    def target_events
      [:opened]
    end
  end

  class SnsConcreteProvider < ConcreteProvider
    def _notify
      aws_config = {}
      aws_config[:region] = region if region
      aws_config[:access_key_id] = access_key_id if access_key_id
      aws_config[:secret_access_key] = secret_access_key if secret_access_key

      sns = Aws::SNS::Client.new(aws_config)

      res = sns.publish(
        topic_arn: topic_arn,
        message: @event.incident.description,
        subject: @event.incident.subject,
        message_attributes: {
          'kind_of_event' => {
            data_type: 'String',
            string_value: kind_of_event.to_s,
          }
        }
      )

      Rails.logger.info res
    end

    private

    def topic_arn
      settings.fetch('topic_arn')
    end

    def region
      settings['region']
    end

    def access_key_id
      settings['access_key_id']
    end

    def secret_access_key
      settings['secret_access_key']
    end

    def target_events
      all_events
    end
  end
end
