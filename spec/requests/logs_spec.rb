require 'spec_helper'

describe "Logs", :type => :request do
  describe "GET /logs" do
    it "works!" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get logs_path
      expect(response.status).to be(302)
    end
  end
end
