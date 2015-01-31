class HomeController < ApplicationController
  def index
    redirect_to incidents_path
  end
end
