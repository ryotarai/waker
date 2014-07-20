require "rails_helper"

RSpec.describe ProvidersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/providers").to route_to("providers#index")
    end

    it "routes to #new" do
      expect(:get => "/providers/new").to route_to("providers#new")
    end

    it "routes to #show" do
      expect(:get => "/providers/1").to route_to("providers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/providers/1/edit").to route_to("providers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/providers").to route_to("providers#create")
    end

    it "routes to #update" do
      expect(:put => "/providers/1").to route_to("providers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/providers/1").to route_to("providers#destroy", :id => "1")
    end

  end
end
