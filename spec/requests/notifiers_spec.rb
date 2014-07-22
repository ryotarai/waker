require 'rails_helper'

RSpec.describe "Notifiers", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "get /notifiers" do
    it "returns notifiers" do
      notifier = create(:notifier)
      get notifiers_path, default_params
      expect(json_response[0]['id']).to eq(notifier.id)
      expect(json_response[0]['name']).to eq(notifier.name)
      expect(json_response[0]['kind']).to eq(notifier.kind)
      expect(json_response[0]['notify_after']).to eq(notifier.notify_after)
      expect(json_response[0]['user']['id']).to eq(notifier.user.id)
      expect(json_response[0]['details']).to eq(notifier.details)
      expect(response.status).to be(200)
    end
  end

  describe "get /notifiers/1" do
    it "returns a notifier" do
      notifier = create(:notifier)
      get notifier_path(notifier), default_params
      expect(json_response['id']).to eq(notifier.id)
      expect(json_response['name']).to eq(notifier.name)
      expect(json_response['kind']).to eq(notifier.kind)
      expect(json_response['notify_after']).to eq(notifier.notify_after)
      expect(json_response['user']['id']).to eq(notifier.user.id)
      expect(json_response['details']).to eq(notifier.details)
      expect(response.status).to be(200)
    end
  end

  describe "POST /notifiers" do
    it "creates a notifier" do
      user = create(:user)
      attributes = attributes_for(:notifier).merge(user_id: user.id)
      post notifiers_path, default_params.merge(notifier: attributes)
      expect(Notifier.last.name).to eq(attributes[:name])
      expect(Notifier.last.kind).to eq(attributes[:kind])
      expect(Notifier.last.notify_after).to eq(attributes[:notify_after])
      expect(Notifier.last.user.id).to eq(attributes[:user_id])
      expect(Notifier.last.details).to eq(attributes[:details])
      expect(response.status).to be(201)
    end
  end
end
