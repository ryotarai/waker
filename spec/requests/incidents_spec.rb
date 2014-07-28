require 'rails_helper'

RSpec.describe "Incidents", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "GET /api/v1/incidents" do
    it "returns incidents" do
      incident = create(:incident)
      get api_incidents_path, default_params
      incident.reload
      expect(response.body).to be_json_as([{
        'id' => incident.id,
        'description' => incident.description,
        'provider' => {
          'id' => incident.provider.id,
          'name' => incident.provider.name,
          'kind' => incident.provider.kind,
          'details' => incident.provider.details,
          'escalation_rule_id' => incident.provider.escalation_rule.id,
          'created_at' => incident.provider.created_at.as_json,
          'updated_at' => incident.provider.updated_at.as_json,
        },
        'status' => incident.status,
        'details' => incident.details,
        'url' => api_incident_url(incident, format: :json),
      }])
      expect(response.status).to be(200)
    end
  end

  describe "GET /api/v1/incidents/1" do
    it "returns an incident" do
      incident = create(:incident)
      get api_incident_path(incident), default_params
      incident.reload
      expect(response.body).to be_json_as({
        'id' => incident.id,
        'description' => incident.description,
        'provider' => {
          'id' => incident.provider.id,
          'name' => incident.provider.name,
          'kind' => incident.provider.kind,
          'details' => incident.provider.details,
          'escalation_rule_id' => incident.provider.escalation_rule.id,
          'created_at' => incident.provider.created_at.as_json,
          'updated_at' => incident.provider.updated_at.as_json,
        },
        'status' => incident.status,
        'details' => incident.details,
        'created_at' => incident.created_at.as_json,
        'updated_at' => incident.updated_at.as_json,
      })
      expect(response.status).to be(200)
    end
  end

  describe "POST /api/v1/incidents" do
    it "creates an incident" do
      provider = create(:provider)
      attributes = attributes_for(:incident).merge(provider_id: provider.id)
      post api_incidents_path, default_params.merge(incident: attributes)
      incident = Incident.last
      expect(incident.description).to eq(attributes[:description])
      expect(incident.provider.id).to eq(attributes[:provider_id])
      expect(incident.details).to eq(attributes[:details])
      expect(response.status).to be(201)
    end
  end
end
