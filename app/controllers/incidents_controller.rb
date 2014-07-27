class IncidentsController < ApplicationController
  before_action :set_incident, only: [:show, :edit, :update, :destroy, :acknowledge, :resolve]

  rescue_from Incident::Error, with: :incident_error

  def index
    @incidents = Incident.all
    respond_with(@incidents)
  end

  def show
    respond_with(@incident)
  end

#  def new
#    @incident = Incident.new
#    respond_with(@incident)
#  end
#
#  def edit
#  end

  def create
    @incident = Incident.new(incident_params)
    @incident.save
    respond_with(@incident)
  end

#  def update
#    @incident.update(incident_params)
#    respond_with(@incident)
#  end
#
#  def destroy
#    @incident.destroy
#    respond_with(@incident)
#  end

  def acknowledge
    @incident.acknowledge
    respond_with(@incident)
  end

  def resolve
    @incident.resolve
    respond_with(@incident)
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
