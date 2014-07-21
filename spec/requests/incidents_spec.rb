require 'rails_helper'

RSpec.describe "Incidents", :type => :request do
  describe "GET /incidents" do
    it "works! (now write some real specs)" do
      get incidents_path
      expect(response.status).to be(200)
    end
  end
end
