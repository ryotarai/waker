module Api
  class IncidentsController < ApplicationController
    before_action :set_incident, only: [:show, :edit, :update, :destroy, :acknowledge, :resolve]

    rescue_from Incident::Error, with: :incident_error
    http_basic_authenticate_with name: ENV['TWILIO_BASIC_AUTH_USER'], password: ENV['TWILIO_BASIC_AUTH_PASSWORD'], only: [:twilio]

    def index
      @incidents = Incident.all
      respond_with(:api, @incidents)
    end

    def show
      respond_with(:api, @incident)
    end

  #  def new
  #    @incident = Incident.new
  #    respond_with(:api, @incident)
  #  end
  #
  #  def edit
  #  end

    def create
      @incident = Incident.new(incident_params)
      @incident.save
      respond_with(:api, @incident)
    end

  #  def update
  #    @incident.update(incident_params)
  #    respond_with(:api, @incident)
  #  end
  #
  #  def destroy
  #    @incident.destroy
  #    respond_with(:api, @incident)
  #  end

    def acknowledge
      @incident.acknowledge
      respond_to do |format|
        format.json { render json: {'message' => 'The incident became acknowledged.'} }
      end
    end

    def resolve
      @incident.resolve
      respond_to do |format|
        format.json { render json: {'message' => 'The incident became resolved.'} }
      end
    end

    def twilio
      @incident = Incident.find(params_without_checking_method[:id])

      if params_without_checking_method[:Digits]
        case params_without_checking_method[:Digits]
        when '1'
          @incident.acknowledge
        when '2'
          @incident.resolve
        end
      end

      resp = Twilio::TwiML::Response.new do |r|
        #r.Say 'Waker', voice: 'alice', language: 'ja-JP'
        r.gather timeout: 10, numDigits: 1 do |g|
          g.Say "This is Waker alert.", voice: 'alice', language: 'en-US'
          g.Say @incident.description, voice: 'alice', language: 'en-US'
          g.Say "To acknowledge, press 1.", voice: 'alice', language: 'en-US'
          g.Say "To resolve, press 2.", voice: 'alice', language: 'en-US'
        end
      end

      render xml: resp.text
    end

    private
      def incident_error(error)
        respond_to do |format|
          format.json { render json: {error: error.message} }
        end
      end

      def set_incident
        @incident = Incident.find(params[:id])
      end

      def incident_params
        incident = params.require(:incident)
        incident.permit(:description, :provider_id, :provider).tap do |permitted|
          permitted[:details] = incident[:details]
        end
      end
  end
end
