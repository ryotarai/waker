class EscalationSeriesController < ApplicationController
  before_action :set_escalation_series, only: [:show, :edit, :update, :destroy, :update_escalations]

  # GET /escalation_series
  # GET /escalation_series.json
  def index
    @escalation_series = EscalationSeries.all
  end

  # GET /escalation_series/1
  # GET /escalation_series/1.json
  def show
  end

  # GET /escalation_series/new
  def new
    @escalation_series = EscalationSeries.new
  end

  # GET /escalation_series/1/edit
  def edit
  end

  # POST /escalation_series
  # POST /escalation_series.json
  def create
    @escalation_series = EscalationSeries.new(escalation_series_params)

    respond_to do |format|
      if @escalation_series.save
        format.html { redirect_to @escalation_series, notice: 'Escalation series was successfully created.' }
        format.json { render :show, status: :created, location: @escalation_series }
      else
        format.html { render :new }
        format.json { render json: @escalation_series.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /escalation_series/1
  # PATCH/PUT /escalation_series/1.json
  def update
    respond_to do |format|
      if @escalation_series.update(escalation_series_params)
        format.html { redirect_to @escalation_series, notice: 'Escalation series was successfully updated.' }
        format.json { render :show, status: :ok, location: @escalation_series }
      else
        format.html { render :edit }
        format.json { render json: @escalation_series.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /escalation_series/1
  # DELETE /escalation_series/1.json
  def destroy
    @escalation_series.destroy
    respond_to do |format|
      format.html { redirect_to escalation_series_index_url, notice: 'Escalation series was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_escalations
    @escalation_series.update_escalations!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_escalation_series
      @escalation_series = EscalationSeries.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def escalation_series_params
      params.require(:escalation_series).permit(:name, :settings).tap do |v|
        v[:settings] = YAML.load(v[:settings])
      end
    end
end
