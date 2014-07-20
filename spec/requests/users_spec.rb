require 'rails_helper'

RSpec.describe "Users", :type => :request do
  describe "GET /users" do
    it "works! (now write some real specs)" do
      get users_path
      expect(response.status).to be(200)
    end
  end
end
