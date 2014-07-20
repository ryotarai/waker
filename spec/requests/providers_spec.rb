require 'rails_helper'

RSpec.describe "Providers", :type => :request do
  describe "GET /providers" do
    it "works! (now write some real specs)" do
      get providers_path
      expect(response.status).to be(200)
    end
  end
end
