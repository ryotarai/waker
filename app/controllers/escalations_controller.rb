class EscalationsController < ApplicationController
  before_action :set_escalation, only: [:show, :edit, :update, :destroy]

  def index
    @escalations = Escalation.all
    respond_with(@escalations)
  end

  def show
    respond_with(@escalation)
  end

  def new
    @escalation = Escalation.new
    respond_with(@escalation)
  end

  def edit
  end

  def create
    @escalation = Escalation.new(escalation_params)
    @escalation.save
    respond_with(@escalation)
  end

  def update
    @escalation.update(escalation_params)
    respond_with(@escalation)
  end

  def destroy
    @escalation.destroy
    respond_with(@escalation)
  end

  private
    def set_escalation
      @escalation = Escalation.find(params[:id])
    end

    def escalation_params
      params.require(:escalation).permit(:rule)
    end
end
