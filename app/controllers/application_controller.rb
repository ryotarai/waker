class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  respond_to :json

  protected
  def json_request?
    request.format.json?
  end

  def json_params
    json = JSON.parse(env['rack.request.form_vars'])
    ActionController::Parameters.new(json)
  end
  
  def params_with_checking_method
    if request.get? || Rails.env.test?
      params_without_checking_method
    else
      params_without_checking_method.merge(json_params)
    end
  end
  alias_method_chain :params, :checking_method
end
