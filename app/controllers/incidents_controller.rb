class IncidentsController < ApplicationController
  before_action :set_incident, only: [:show, :edit, :update, :destroy, :acknowledge, :resolve]
  before_action :ensure_hash, only: [:acknowledge, :resolve]

  # GET /incidents
  # GET /incidents.json
  def index
    case params[:status]
    when 'opened'
      @incidents = Incident.opened
    when 'acknowledged'
      @incidents = Incident.acknowledged
    when 'resolved'
      @incidents = Incident.resolved
    else
      @incidents = Incident.all
    end

    @page = (params[:page] || 1).to_i
    @incidents = @incidents.order('id DESC').page(@page).per(25)
  end

  # GET /incidents/1
  # GET /incidents/1.json
  def show
  end

  # GET /incidents/new
  def new
    @incident = Incident.new
  end

  # GET /incidents/1/edit
  def edit
  end

  # POST /incidents
  # POST /incidents.json
  def create
    @incident = Incident.new(incident_params)

    respond_to do |format|
      if @incident.save
        format.html { redirect_to @incident, notice: 'Incident was successfully created.' }
        format.json { render :show, status: :created, location: @incident }
      else
        format.html { render :new }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incidents/1
  # PATCH/PUT /incidents/1.json
  def update
    respond_to do |format|
      if @incident.update(incident_params)
        format.html { redirect_to @incident, notice: 'Incident was successfully updated.' }
        format.json { render :show, status: :ok, location: @incident }
      else
        format.html { render :edit }
        format.json { render json: @incident.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incidents/1
  # DELETE /incidents/1.json
  def destroy
    @incident.destroy
    respond_to do |format|
      format.html { redirect_to incidents_url, notice: 'Incident was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def acknowledge
    @incident.acknowledge!
    respond_to do |format|
      format.html { redirect_to incidents_url, notice: 'Incident was successfully acknowledged.' }
      format.json { head :no_content }
    end
  end

  def resolve
    @incident.resolve!
    respond_to do |format|
      format.html { redirect_to incidents_url, notice: 'Incident was successfully resolved.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incident
      @incident = Incident.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def incident_params
      params.require(:incident).permit(:subject, :description, :topic_id, :occured_at)
    end

    def ensure_hash
      unless params[:hash] == @incident.confirmation_hash
        render text: "Wrong hash", status: 403
      end
    end
end
