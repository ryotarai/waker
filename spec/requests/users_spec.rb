require 'rails_helper'

RSpec.describe "Users", :type => :request do
  let(:default_params) do
    {format: :json}
  end

  describe "GET /users" do
    it "returns users" do
      user = create(:user)
      get users_path, default_params
      expect(json_response[0]['id']).to eq(user.id)
      expect(json_response[0]['name']).to eq(user.name)
      expect(response.status).to be(200)
    end
  end

  describe "GET /users/1" do
    it "return a user" do
      user = create(:user)
      get user_path(user), default_params
      expect(json_response['id']).to eq(user.id)
      expect(json_response['name']).to eq(user.name)
      expect(response.status).to be(200)
    end
  end

  describe "POST /users" do
    it "creates a new user" do
      post users_path, default_params.merge(user: {name: 'Bob'})
      expect(User.last.name).to eq('Bob')
      expect(response.status).to be(201)
    end
  end
end
