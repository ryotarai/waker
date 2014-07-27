require 'rails_helper'

RSpec.describe "Providers", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "GET /api/v1/providers" do
    it "returns providers" do
      provider = create(:provider)
      get api_providers_path, default_params
      expect(response.body).to be_json_as([{
        'id' => provider.id,
        'name' => provider.name,
        'kind' => provider.kind,
        'details' => provider.details,
        'escalation_rule_id' => provider.escalation_rule.id,
        'url' => api_provider_url(provider, format: :json),
      }])
      expect(response.status).to be(200)
    end
  end

  describe "GET /api/v1/provider/1" do
    it "returns a provider" do
      provider = create(:provider)
      get api_provider_path(provider), default_params
      expect(response.body).to be_json_as({
        'id' => provider.id,
        'name' => provider.name,
        'kind' => provider.kind,
        'details' => provider.details,
        'escalation_rule_id' => provider.escalation_rule.id,
        'updated_at' => provider.updated_at.as_json,
        'created_at' => provider.created_at.as_json,
      })
      expect(response.status).to be(200)
    end
  end

  describe "POST /api/v1/providers" do
    it "creates a provider" do
      escalation_rule = create(:escalation_rule)
      attributes = attributes_for(:provider).merge(escalation_rule_id: escalation_rule.id)
      post api_providers_path, default_params.merge(provider: attributes)
      provider = Provider.last
      expect(provider.name).to eq attributes[:name]
      expect(provider.kind).to eq attributes[:kind]
      expect(provider.details).to eq attributes[:details]
      expect(provider.escalation_rule).to eq escalation_rule
      expect(response.status).to be(201)
    end
  end
end
