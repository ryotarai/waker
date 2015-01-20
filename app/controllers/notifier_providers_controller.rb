class NotifierProvidersController < ApplicationController
  before_action :set_notifier_provider, only: [:show, :edit, :update, :destroy]

  # GET /notifier_providers
  # GET /notifier_providers.json
  def index
    @notifier_providers = NotifierProvider.all
  end

  # GET /notifier_providers/1
  # GET /notifier_providers/1.json
  def show
  end

  # GET /notifier_providers/new
  def new
    @notifier_provider = NotifierProvider.new
  end

  # GET /notifier_providers/1/edit
  def edit
  end

  # POST /notifier_providers
  # POST /notifier_providers.json
  def create
    @notifier_provider = NotifierProvider.new(notifier_provider_params)

    respond_to do |format|
      if @notifier_provider.save
        format.html { redirect_to @notifier_provider, notice: 'Notifier provider was successfully created.' }
        format.json { render :show, status: :created, location: @notifier_provider }
      else
        format.html { render :new }
        format.json { render json: @notifier_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifier_providers/1
  # PATCH/PUT /notifier_providers/1.json
  def update
    respond_to do |format|
      if @notifier_provider.update(notifier_provider_params)
        format.html { redirect_to @notifier_provider, notice: 'Notifier provider was successfully updated.' }
        format.json { render :show, status: :ok, location: @notifier_provider }
      else
        format.html { render :edit }
        format.json { render json: @notifier_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifier_providers/1
  # DELETE /notifier_providers/1.json
  def destroy
    @notifier_provider.destroy
    respond_to do |format|
      format.html { redirect_to notifier_providers_url, notice: 'Notifier provider was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notifier_provider
      @notifier_provider = NotifierProvider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notifier_provider_params
      params.require(:notifier_provider).permit(:name, :kind, :settings).tap do |v|
        v[:settings] = YAML.load(v[:settings])
      end
    end
end
