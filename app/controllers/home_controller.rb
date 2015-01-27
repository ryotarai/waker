class HomeController < ApplicationController
  def index
    redirect_to incidents_path(status: :opened)
  end
end
