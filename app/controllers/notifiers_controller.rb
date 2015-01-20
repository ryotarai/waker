class NotifiersController < ApplicationController
  before_action :set_notifier, only: [:show, :edit, :update, :destroy]

  # GET /notifiers
  # GET /notifiers.json
  def index
    @notifiers = Notifier.all
  end

  # GET /notifiers/1
  # GET /notifiers/1.json
  def show
  end

  # GET /notifiers/new
  def new
    @notifier = Notifier.new
  end

  # GET /notifiers/1/edit
  def edit
  end

  # POST /notifiers
  # POST /notifiers.json
  def create
    @notifier = Notifier.new(notifier_params)

    respond_to do |format|
      if @notifier.save
        format.html { redirect_to @notifier, notice: 'Notifier was successfully created.' }
        format.json { render :show, status: :created, location: @notifier }
      else
        format.html { render :new }
        format.json { render json: @notifier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notifiers/1
  # PATCH/PUT /notifiers/1.json
  def update
    respond_to do |format|
      if @notifier.update(notifier_params)
        format.html { redirect_to @notifier, notice: 'Notifier was successfully updated.' }
        format.json { render :show, status: :ok, location: @notifier }
      else
        format.html { render :edit }
        format.json { render json: @notifier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifiers/1
  # DELETE /notifiers/1.json
  def destroy
    @notifier.destroy
    respond_to do |format|
      format.html { redirect_to notifiers_url, notice: 'Notifier was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notifier
      @notifier = Notifier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notifier_params
      params.require(:notifier).permit(:user_id, :kind, :settings, :notify_after_sec, :provider_id).tap do |v|
        v[:settings] = YAML.load(v[:settings])
      end
    end
end
