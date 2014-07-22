require 'rails_helper'

RSpec.describe "Incidents", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "GET /incidents" do
    it "returns incidents" do
      incident = create(:incident)
      get incidents_path, default_params
      expect(json_response[0]['id']).to eq(incident.id)
      expect(json_response[0]['description']).to eq(incident.description)
      expect(json_response[0]['provider']['id']).to eq(incident.provider.id)
      expect(json_response[0]['details']).to eq(incident.details)
      expect(response.status).to be(200)
    end
  end

  describe "GET /incidents/1" do
    it "returns an incident" do
      incident = create(:incident)
      get incident_path(incident), default_params
      expect(json_response['id']).to eq(incident.id)
      expect(json_response['description']).to eq(incident.description)
      expect(json_response['provider']['id']).to eq(incident.provider.id)
      expect(json_response['details']).to eq(incident.details)
      expect(response.status).to be(200)
    end
  end

  describe "POST /incidents" do
    it "creates an incident" do
      provider = create(:provider)
      attributes = attributes_for(:incident).merge(provider_id: provider.id)
      post incidents_path, default_params.merge(incident: attributes)
      expect(Incident.last.description).to eq(attributes[:description])
      expect(Incident.last.provider.id).to eq(attributes[:provider_id])
      expect(Incident.last.details).to eq(attributes[:details])
      expect(response.status).to be(201)
    end
  end
end
