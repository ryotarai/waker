class SessionsController < ApplicationController
  skip_before_action :login_required

  def create
    if google_domain = ENV['GOOGLE_DOMAIN']
      unless google_domain == domain
        render text: "Invalid domain."
        return
      end
    end

    @user = User.find_from_auth_hash(auth_hash)

    unless @user
      render text: "You are not authorized."
      return
    end

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
