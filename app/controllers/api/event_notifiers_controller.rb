class EventNotifiersController < ApplicationController
  before_action :set_event_notifier, only: [:show, :edit, :update, :destroy]

  def index
    @event_notifiers = EventNotifier.all
    respond_with(:api, @event_notifiers)
  end

  def show
    respond_with(:api, @event_notifier)
  end

  def new
    @event_notifier = EventNotifier.new
    respond_with(:api, @event_notifier)
  end

  def edit
  end

  def create
    @event_notifier = EventNotifier.new(event_notifier_params)
    @event_notifier.save
    respond_with(:api, @event_notifier)
  end

  def update
    @event_notifier.update(event_notifier_params)
    respond_with(:api, @event_notifier)
  end

  def destroy
    @event_notifier.destroy
    respond_with(:api, @event_notifier)
  end

  private
    def set_event_notifier
      @event_notifier = EventNotifier.find(params[:id])
    end

    def event_notifier_params
      params.require(:event_notifier).permit(:kind, :details_json)
    end
end
