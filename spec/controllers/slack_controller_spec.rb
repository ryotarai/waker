require 'rails_helper'

RSpec.describe SlackController, :type => :controller do

  describe "GET interactive" do
    it "returns http success" do
      get :interactive
      expect(response).to have_http_status(:success)
    end
  end

end
