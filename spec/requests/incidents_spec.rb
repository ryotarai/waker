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

  describe "GET /api/v1/incidents/1/acknowledge" do
    context "with correct hash" do
      it "makes the incident acknowledged" do
        incident = create(:incident)
        get acknowledge_api_incident_path(incident, hash: incident.check_hash), default_params
        incident.reload
        expect(incident).to be_acknowledged
      end
    end

    context "with incorrect hash" do
      it "doesn't make the incident acknowledged" do
        incident = create(:incident)
        get acknowledge_api_incident_path(incident, hash: "incorrecthash"), default_params
        incident.reload
        expect(incident).not_to be_acknowledged
      end
    end
  end

  describe "GET /api/v1/incidents/1/resolve" do
    context "with correct hash" do
      it "makes the incident resolved" do
        incident = create(:incident)
        get resolve_api_incident_path(incident, hash: incident.check_hash), default_params
        incident.reload
        expect(incident).to be_resolved
      end
    end

    context "with incorrect hash" do
      it "doesn't make the incident resolved" do
        incident = create(:incident)
        get resolve_api_incident_path(incident, hash: "incorrecthash"), default_params
        incident.reload
        expect(incident).not_to be_resolved
      end
    end
  end

  describe "GET /api/v1/incidents/1/twilio" do
    context "with Digits 1" do
      it "makes the incident acknowledged" do
        incident = create(:incident)
        get twilio_api_incident_path(incident), default_params.merge(Digits: '1')
        incident.reload
        expect(incident).to be_acknowledged
        expect(response.body).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Say voice=\"alice\" language=\"en-US\">acknowledged</Say><Hangup/></Response>")
      end
    end

    context "with Digits 2" do
      it "makes the incident resolved" do
        incident = create(:incident)
        get twilio_api_incident_path(incident), default_params.merge(Digits: '2')
        incident.reload
        expect(incident).to be_resolved
        expect(response.body).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Say voice=\"alice\" language=\"en-US\">resolved</Say><Hangup/></Response>")
      end
    end

    context "without Digits param" do
      it "returns TwiML" do
        incident = create(:incident)
        get twilio_api_incident_path(incident), default_params
        expect(response.body).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><Response><Gather timeout=\"10\" numDigits=\"1\"><Say voice=\"alice\" language=\"en-US\">This is Waker alert.</Say><Say voice=\"alice\" language=\"en-US\">content</Say><Say voice=\"alice\" language=\"en-US\">To acknowledge, press 1.</Say><Say voice=\"alice\" language=\"en-US\">To resolve, press 2.</Say></Gather></Response>")
      end
    end
  end
end
