require 'rails_helper'

RSpec.describe SlackController, :type => :controller do

  describe "GET interactive" do
    it "raises token verification failed error" do
      expect(get: 'slack/interactive').not_to be_routable
      expect{get :interactive}.to raise_error(RuntimeError, /token verification failed/)
    end
  end

end
