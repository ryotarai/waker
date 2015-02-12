require 'rails_helper'

RSpec.describe "Notifiers", :type => :request do
  describe "GET /notifiers" do
    it "works! (now write some real specs)" do
      get notifiers_path
      expect(response).to have_http_status(200)
    end
  end
end
