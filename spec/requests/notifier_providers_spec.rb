require 'rails_helper'

RSpec.describe "NotifierProviders", :type => :request do
  describe "GET /notifier_providers" do
    it "works! (now write some real specs)" do
      get notifier_providers_path
      expect(response).to have_http_status(200)
    end
  end
end
