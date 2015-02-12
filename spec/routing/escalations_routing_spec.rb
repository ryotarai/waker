require "rails_helper"

RSpec.describe EscalationsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/escalations").to route_to("escalations#index")
    end

    it "routes to #new" do
      expect(:get => "/escalations/new").to route_to("escalations#new")
    end

    it "routes to #show" do
      expect(:get => "/escalations/1").to route_to("escalations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/escalations/1/edit").to route_to("escalations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/escalations").to route_to("escalations#create")
    end

    it "routes to #update" do
      expect(:put => "/escalations/1").to route_to("escalations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/escalations/1").to route_to("escalations#destroy", :id => "1")
    end

  end
end
