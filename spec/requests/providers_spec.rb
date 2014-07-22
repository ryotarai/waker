require 'rails_helper'

RSpec.describe "Providers", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "GET /providers" do
    it "returns providers" do
      provider = create(:provider)
      get providers_path, default_params
      expect(json_response[0]['id']).to eq(provider.id)
      expect(json_response[0]['name']).to eq(provider.name)
      expect(json_response[0]['kind']).to eq(provider.kind)
      expect(json_response[0]['details']).to eq(provider.details)
      expect(response.status).to be(200)
    end
  end

  describe "GET /provider/1" do
    it "returns a provider" do
      provider = create(:provider)
      get provider_path(provider), default_params
      expect(json_response['id']).to eq(provider.id)
      expect(json_response['name']).to eq(provider.name)
      expect(json_response['kind']).to eq(provider.kind)
      expect(json_response['details']).to eq(provider.details)
      expect(response.status).to be(200)
    end
  end

  describe "POST /providers" do
    it "creates a provider" do
      attributes = attributes_for(:provider)
      post providers_path, default_params.merge(provider: attributes)
      expect(Provider.last.name).to eq(attributes[:name])
      expect(Provider.last.kind).to eq(attributes[:kind])
      expect(Provider.last.details).to eq(attributes[:details])
      expect(response.status).to be(201)
    end
  end
end
