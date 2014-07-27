module Api
  class NotifiersController < ApplicationController
    before_action :set_notifier, only: [:show, :edit, :update, :destroy]

    def index
      @notifiers = Notifier.all
      respond_with(:api, @notifiers)
    end

    def show
      respond_with(:api, @notifier)
    end

  #  def new
  #    @notifier = Notifier.new
  #    respond_with(@notifier)
  #  end
  #
  #  def edit
  #  end

    def create
      @notifier = Notifier.new(notifier_params)
      @notifier.save
      respond_with(:api, @notifier)
    end

    def update
      @notifier.update(notifier_params)
      respond_with(:api, @notifier)
    end

    def destroy
      @notifier.destroy
      respond_with(:api, @notifier)
    end

    private
      def set_notifier
        @notifier = Notifier.find(params[:id])
      end

      def notifier_params
        notifier = params.require(:notifier)
        notifier.permit(:name, :user_id, :notify_after, :kind).tap do |permitted|
          permitted[:details] = notifier[:details]
        end
      end
  end
end
