require "spec_helper"

describe LogsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get("/logs")).to route_to("logs#index")
    end

  end
end
