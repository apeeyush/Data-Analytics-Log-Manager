require 'spec_helper'

RSpec.describe "DataQueries", :type => :request do
  describe "GET /data_queries" do
    it "works! (redirects when not signed-in)" do
      get data_queries_path
      expect(response.status).to be(302)
    end
  end
end
