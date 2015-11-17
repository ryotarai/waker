class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  helper_method :current_user

  before_action :login_required

  private

  def login_required
    unless current_user
      session[:user_id] = nil
      redirect_to '/auth/google_oauth2'
      return
    end

    unless current_user.active
      render text: "You are not activated yet. Please ask administrator to activate you"
      return
    end
  end

  def current_user=(user)
    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      User.find(user_id)
    elsif login_token = request.headers['X-Login-Token']
      User.find_by(login_token: login_token)
    end
  end
end
