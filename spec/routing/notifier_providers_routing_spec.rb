require "rails_helper"

RSpec.describe NotifierProvidersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/notifier_providers").to route_to("notifier_providers#index")
    end

    it "routes to #new" do
      expect(:get => "/notifier_providers/new").to route_to("notifier_providers#new")
    end

    it "routes to #show" do
      expect(:get => "/notifier_providers/1").to route_to("notifier_providers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/notifier_providers/1/edit").to route_to("notifier_providers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/notifier_providers").to route_to("notifier_providers#create")
    end

    it "routes to #update" do
      expect(:put => "/notifier_providers/1").to route_to("notifier_providers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/notifier_providers/1").to route_to("notifier_providers#destroy", :id => "1")
    end

  end
end
