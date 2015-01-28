require 'rails_helper'

RSpec.describe IncidentEventsController, :type => :controller do

  describe "GET twilio" do
    it "returns http success" do
      get :twilio
      expect(response).to have_http_status(:success)
    end
  end

end
