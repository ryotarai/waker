require 'rails_helper'

RSpec.describe "Notifiers", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "get /api/v1/notifiers" do
    it "returns notifiers" do
      notifier = create(:notifier)
      get api_notifiers_path, default_params
      notifier.reload
      expect(response.body).to be_json_as([{
        'id' => notifier.id,
        'name' => notifier.name,
        'kind' => notifier.kind,
        'notify_after' => notifier.notify_after,
        'user' => {
          'id' => notifier.user.id,
          'name' => notifier.user.name,
          'updated_at' => notifier.user.updated_at.as_json,
          'created_at' => notifier.user.created_at.as_json,
        },
        'details' => notifier.details,
        'url' => api_notifier_url(notifier, format: :json),
      }])
      expect(response.status).to be(200)
    end
  end

  describe "get /api/v1/notifiers/1" do
    it "returns a notifier" do
      notifier = create(:notifier)
      get api_notifier_path(notifier), default_params
      notifier.reload
      expect(response.body).to be_json_as({
        'id' => notifier.id,
        'name' => notifier.name,
        'kind' => notifier.kind,
        'notify_after' => notifier.notify_after,
        'user' => {
          'id' => notifier.user.id,
          'name' => notifier.user.name,
          'updated_at' => notifier.user.updated_at.as_json,
          'created_at' => notifier.user.created_at.as_json,
        },
        'details' => notifier.details,
        'updated_at' => notifier.updated_at.as_json,
        'created_at' => notifier.created_at.as_json,
      })
      expect(response.status).to be(200)
    end
  end

  describe "POST /api/v1/notifiers" do
    it "creates a notifier" do
      user = create(:user)
      attributes = attributes_for(:notifier).merge(user_id: user.id)
      post api_notifiers_path, default_params.merge(notifier: attributes)
      notifier = Notifier.last
      expect(notifier.name).to eq(attributes[:name])
      expect(notifier.kind).to eq(attributes[:kind])
      expect(notifier.notify_after).to eq(attributes[:notify_after])
      expect(notifier.user.id).to eq(attributes[:user_id])
      expect(notifier.details).to eq(attributes[:details])
      expect(response.status).to be(201)
    end
  end
end
