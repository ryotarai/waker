require 'securerandom'

class IncidentEventsController < ApplicationController
  BASIC_AUTH_USER = 'waker'
  BASIC_AUTH_PASSWORD = SecureRandom.hex(8)

  http_basic_authenticate_with(
    name: BASIC_AUTH_USER,
    password: BASIC_AUTH_PASSWORD,
    only: [:twilio],
  )

  def twilio
    @event = IncidentEvent.find(params[:id])
    resp = nil

    if params[:Digits]
      case params[:Digits]
      when '1'
        @event.incident.acknowledge rescue nil
      when '2'
        @event.incident.resolve rescue nil
      end
      resp = Twilio::TwiML::Response.new do |r|
        r.Say @event.incident.status, voice: 'alice', language: 'en-US'
        r.Hangup
      end
    else
      resp = Twilio::TwiML::Response.new do |r|
        r.Gather timeout: 10, numDigits: 1 do |g|
          g.Say "This is Waker alert.", voice: 'alice', language: 'en-US'
          g.Say @event.incident.subject, voice: 'alice', language: 'en-US'
          g.Say "To acknowledge, press 1.", voice: 'alice', language: 'en-US'
          g.Say "To resolve, press 2.", voice: 'alice', language: 'en-US'
        end
      end
    end

    render xml: resp.text
  end
end
