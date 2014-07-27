class NotifierMailer < ActionMailer::Base
  class Error < StandardError; end

  default from: ENV['MAIL_FROM']

  def incident(notifier, incident)
    @notifier = notifier
    @incident = incident

    to = @notifier.details['to']
    unless to
      raise Error, "notifier.details['to'] is not set"
    end

    mail(to: to, subject: "[Waker ALERT] #{@incident.description}")
  end
end
