require 'rails_helper'

RSpec.describe "DataQueries", :type => :request do
  describe "GET /data_queries" do
    it "works! (now write some real specs)" do
      get data_queries_path
      expect(response.status).to be(200)
    end
  end
end
