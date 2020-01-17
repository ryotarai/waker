require 'rails_helper'

RSpec.describe "Maintenances", type: :request do
  describe "GET /maintenances" do
    it "works! (now write some real specs)" do
      get maintenances_path
      expect(response).to have_http_status(302)
    end
  end
end
