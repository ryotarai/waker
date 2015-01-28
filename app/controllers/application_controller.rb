class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :login_required

  private

  def login_required
    unless current_user
      redirect_to '/auth/google_oauth2'
    end
  end

  def current_user=(user)
    session[:user_id] = user.id
  end

  def current_user
    if user_id = session[:user_id]
      User.find(user_id)
    end
  end
end
