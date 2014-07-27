module Api
  class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    def index
      @users = User.all
      respond_with(:api, @users)
    end

    def show
      respond_with(:api, @user)
    end

  #  def new
  #    @user = User.new
  #    respond_with(:api, @user)
  #  end
  #
  #  def edit
  #  end

    def create
      @user = User.new(user_params)
      @user.save
      respond_with(:api, @user)
    end

    def update
      @user.update(user_params)
      respond_with(:api, @user)
    end

    def destroy
      @user.destroy
      respond_with(:api, @user)
    end

    private
      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name)
      end
  end
end
