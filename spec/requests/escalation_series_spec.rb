require 'rails_helper'

RSpec.describe "EscalationSeries", :type => :request do
  describe "GET /escalation_series" do
    it "works! (now write some real specs)" do
      get escalation_series_index_path
      expect(response).to have_http_status(200)
    end
  end
end
