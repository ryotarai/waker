class NotifierProvider < ActiveRecord::Base
  KINDS = [:mailgun, :file, :rails_logger]
  serialize :settings, JSON
  enum kind: KINDS

  after_initialize :set_defaults

  def set_defaults
    self.settings ||= {}
  end

  def concrete
    @concrete ||= self.class.const_get("#{kind.to_s.split('_').map(&:capitalize).join}ConcreteProvider").new(self)
  end

  def notify(notifier, incident, event)
    concrete.notify(notifier, incident, event)
  end

  class ConcreteProvider
    def initialize(provider)
      @provider = provider
    end

    def notify(notifier, incident, event)
      _notify(notifier, incident, event)
    end

    def _notify(notifier, incident, event)
      raise NotImplementedError
    end
  end

  class FileConcreteProvider < ConcreteProvider
  end

  class RailsLoggerConcreteProvider < ConcreteProvider
    def _notify(notifier, incident, event)
      Rails.logger.info "#{event}: #{notifier.inspect} #{incident.inspect}"
    end
  end

  class MailgunConcreteProvider < ConcreteProvider
  end
end


