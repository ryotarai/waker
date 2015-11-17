class IncidentsController < ApplicationController
  before_action :set_incidents, only: [:index, :bulk_acknowledge, :bulk_resolve]
  before_action :set_incident, only: [:show, :edit, :update, :destroy, :acknowledge, :resolve]
  before_action :ensure_hash, only: [:acknowledge, :resolve]
  skip_before_action :login_required, only: [:acknowledge, :resolve]

  # GET /incidents
  # GET /incidents.json
  def index
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

  def bulk_acknowledge
    @incidents.opened.update_all(status: Incident.statuses[:acknowledged])
    respond_to do |format|
      format.html { redirect_to incidents_url, notice: 'Incidents were successfully acknowledged.' }
      format.json { head :no_content }
    end
  end

  def bulk_resolve
    @incidents.update_all(status: Incident.statuses[:resolved])
    respond_to do |format|
      format.html { redirect_to incidents_url, notice: 'Incidents were successfully resolved.' }
      format.json { head :no_content }
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
      if current_user
        format.html { redirect_to incidents_url, notice: 'Incident was successfully acknowledged.' }
      else
        format.html { render text: "Acknowledged" }
      end
      format.json { render json: {status: 'ok'} }
    end
  end

  def resolve
    @incident.resolve!
    respond_to do |format|
      if current_user
        format.html { redirect_to incidents_url, notice: 'Incident was successfully resolved.' }
      else
        format.html { render text: "Resolved" }
      end
      format.json { render json: {status: 'ok'} }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incident
      @incident = Incident.find(params[:id])
    end

    def set_incidents
      set_visible_statuses
      set_visible_topic

      @incidents = Incident.all

      if @visible_statuses
        @incidents = @incidents.where(status: @visible_statuses)
      end
      if @visible_topic
        @incidents = @incidents.where(topic: @visible_topic)
      end
    end

    def set_visible_statuses
      @visible_statuses = session[:incidents_statuses]

      # for transition from rev 0a2dd42 or earlier
      @visible_statuses = nil if @visible_statuses.empty?

      if params[:statuses]
        if params[:statuses] == ''
          @visible_statuses = nil # all
        else
          @visible_statuses = params[:statuses].split(',').map(&:to_i)
        end
        session[:incidents_statuses] = @visible_statuses
      end
    end

    def set_visible_topic
      @visible_topic = session[:incidents_topic]

      # for transition from rev 0a2dd42 or earlier
      @visible_topic = nil if @visible_topic == 'all'

      if params[:topic]
        if params[:topic] == 'all'
          @visible_topic = nil # all
        else
          @visible_topic = params[:topic].to_i
        end
        session[:incidents_topic] = @visible_topic
      end
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
