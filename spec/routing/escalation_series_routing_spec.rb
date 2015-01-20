require "rails_helper"

RSpec.describe EscalationSeriesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/escalation_series").to route_to("escalation_series#index")
    end

    it "routes to #new" do
      expect(:get => "/escalation_series/new").to route_to("escalation_series#new")
    end

    it "routes to #show" do
      expect(:get => "/escalation_series/1").to route_to("escalation_series#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/escalation_series/1/edit").to route_to("escalation_series#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/escalation_series").to route_to("escalation_series#create")
    end

    it "routes to #update" do
      expect(:put => "/escalation_series/1").to route_to("escalation_series#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/escalation_series/1").to route_to("escalation_series#destroy", :id => "1")
    end

  end
end
