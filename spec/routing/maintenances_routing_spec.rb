require "rails_helper"

RSpec.describe MaintenancesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/maintenances").to route_to("maintenances#index")
    end

    it "routes to #new" do
      expect(:get => "/maintenances/new").to route_to("maintenances#new")
    end

    it "routes to #show" do
      expect(:get => "/maintenances/1").to route_to("maintenances#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/maintenances/1/edit").to route_to("maintenances#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/maintenances").to route_to("maintenances#create")
    end

    it "routes to #update" do
      expect(:put => "/maintenances/1").to route_to("maintenances#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/maintenances/1").to route_to("maintenances#destroy", :id => "1")
    end

  end
end
