require 'rails_helper'

RSpec.describe "EventNotifiers", :type => :request do
  describe "GET /event_notifiers" do
    it "works! (now write some real specs)" do
      get event_notifiers_path
      expect(response.status).to be(200)
    end
  end
end
