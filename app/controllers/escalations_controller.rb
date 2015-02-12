class EscalationsController < ApplicationController
  before_action :set_escalation, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:update]

  # GET /escalations
  # GET /escalations.json
  def index
    @escalations = Escalation.all.order('escalate_after_sec')
  end

  # GET /escalations/1
  # GET /escalations/1.json
  def show
  end

  # GET /escalations/new
  def new
    @escalation = Escalation.new
  end

  # GET /escalations/1/edit
  def edit
  end

  # POST /escalations
  # POST /escalations.json
  def create
    @escalation = Escalation.new(escalation_params)

    respond_to do |format|
      if @escalation.save
        format.html { redirect_to @escalation, notice: 'Escalation was successfully created.' }
        format.json { render :show, status: :created, location: @escalation }
      else
        format.html { render :new }
        format.json { render json: @escalation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /escalations/1
  # PATCH/PUT /escalations/1.json
  def update
    respond_to do |format|
      if @escalation.update(escalation_params)
        format.html { redirect_to @escalation, notice: 'Escalation was successfully updated.' }
        format.json { render :show, status: :ok, location: @escalation }
      else
        format.html { render :edit }
        format.json { render json: @escalation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /escalations/1
  # DELETE /escalations/1.json
  def destroy
    @escalation.destroy
    respond_to do |format|
      format.html { redirect_to escalations_url, notice: 'Escalation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_escalation
      @escalation = Escalation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def escalation_params
      params.require(:escalation).permit(:escalate_to_id, :escalate_after_sec, :escalation_series_id)
    end
end
