class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:create]

  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user
    redirect_to '/'
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
