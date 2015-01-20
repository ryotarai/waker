require "rails_helper"

RSpec.describe NotifiersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/notifiers").to route_to("notifiers#index")
    end

    it "routes to #new" do
      expect(:get => "/notifiers/new").to route_to("notifiers#new")
    end

    it "routes to #show" do
      expect(:get => "/notifiers/1").to route_to("notifiers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/notifiers/1/edit").to route_to("notifiers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/notifiers").to route_to("notifiers#create")
    end

    it "routes to #update" do
      expect(:put => "/notifiers/1").to route_to("notifiers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/notifiers/1").to route_to("notifiers#destroy", :id => "1")
    end

  end
end
