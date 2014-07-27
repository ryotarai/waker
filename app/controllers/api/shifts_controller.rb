module Api
  class ShiftsController < ApplicationController
    before_action :set_shift, only: [:show, :edit, :update, :destroy]

    def index
      @shifts = Shift.all
      respond_with(:api, @shifts)
    end

    def show
      respond_with(:api, @shift)
    end

  #  def new
  #    @shift = Shift.new
  #    respond_with(:api, @shift)
  #  end
  #
  #  def edit
  #  end

    def create
      @shift = Shift.new(shift_params)
      @shift.save
      respond_with(:api, @shift)
    end

    def update
      @shift.update(shift_params)
      respond_with(:api, @shift)
    end

    def destroy
      @shift.destroy
      respond_with(:api, @shift)
    end

    private
      def set_shift
        @shift = Shift.find(params[:id])
      end

      def shift_params
        params.require(:shift).permit(:name, :ical)
      end
  end
end
