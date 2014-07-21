require 'rails_helper'

RSpec.describe "Escalations", :type => :request do
  describe "GET /escalations" do
    it "works! (now write some real specs)" do
      get escalations_path
      expect(response.status).to be(200)
    end
  end
end
