require "spec_helper"

RSpec.describe DataQueriesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/data_queries").to route_to("data_queries#index")
    end

    it "routes to #new" do
      expect(:get => "/data_queries/new").to route_to("data_queries#new")
    end

    it "routes to #show" do
      expect(:get => "/data_queries/1").to route_to("data_queries#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/data_queries/1/edit").to route_to("data_queries#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/data_queries").to route_to("data_queries#create")
    end

    it "routes to #update" do
      expect(:put => "/data_queries/1").to route_to("data_queries#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/data_queries/1").to route_to("data_queries#destroy", :id => "1")
    end

  end
end
