require 'rails_helper'

RSpec.describe "IncidentEvent", type: :request do
  describe "POST /incident_events/:id/twilio" do
    let(:incident) { create(:incident) }
    let(:event) { create(:incident_event, incident_id: incident.id) }

    describe 'without params[:Digits]' do
      it "works!" do
        post "/incident_events/#{event.id}/twilio"
        expect(response).to have_http_status(200)
      end
    end

    describe 'with params[:Digits]' do
      before do
        post "/incident_events/#{event.id}/twilio", params: { Digits: digit}
        incident.reload
      end

      context '1' do
        let(:digit) { 1 }
        it "acknowledged" do
          expect(response).to have_http_status(200)
          expect(incident.status).to eq 'acknowledged'
        end
      end

      context '2' do
        let(:digit) { 2 }
        it "resolved" do
          expect(response).to have_http_status(200)
          expect(incident.status).to eq 'resolved'
        end
      end
    end
  end
end
