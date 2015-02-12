require 'rails_helper'

RSpec.describe "Incidents", :type => :request do
  describe "GET /incidents" do
    it "works! (now write some real specs)" do
      get incidents_path
      expect(response).to have_http_status(200)
    end
  end
end
