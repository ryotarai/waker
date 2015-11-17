class SessionsController < ApplicationController
  skip_before_action :login_required

  def create
    @user = User.find_from_auth_hash(auth_hash)

    unless @user
      render text: "You are not authorized."
      return
    end

    unless @user.active
      render text: "You are suspended user. Please ask administrator to activate you"
      return
    end

    @user.update!(
      token: auth_hash.credentials.token,
      refresh_token: auth_hash.credentials.refresh_token,
      token_expires_at: Time.at(auth_hash.credentials.expires_at),
    )

    self.current_user = @user
    redirect_to '/'
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def domain
    auth_hash[:info][:email].split('@').last
  end
end
