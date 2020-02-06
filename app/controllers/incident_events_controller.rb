require 'securerandom'

class IncidentEventsController < ApplicationController
  skip_before_action :login_required, only: [:twilio]

  def twilio
    @event = IncidentEvent.find(params[:id])
    language = ENV['TWILIO_LANGUAGE'] || 'en-US'
    resp = nil

    if params[:Digits]
      case params[:Digits]
      when '1'
        @event.incident.acknowledge! rescue nil
      when '2'
        @event.incident.resolve! rescue nil
      end
      resp = Twilio::TwiML::VoiceResponse.new do |r|
        r.Say @event.incident.status, voice: 'alice', language: language
        r.Hangup
      end
    else
      resp = Twilio::TwiML::VoiceResponse.new do |r|
        r.gather timeout: 10, numDigits: 1 do |g|
          g.say message: "This is Waker alert.", voice: 'alice', language: language
          g.say message: @event.incident.subject, voice: 'alice', language: language
          g.say message: "To acknowledge, press 1.", voice: 'alice', language: language
          g.say message: "To resolve, press 2.", voice: 'alice', language: language
        end
      end
    end

    render xml: resp.to_s
  end
end
