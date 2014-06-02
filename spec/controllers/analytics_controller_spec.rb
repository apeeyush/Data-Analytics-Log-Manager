require 'spec_helper'

describe AnalyticsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'all'" do
    it "returns http success" do
      get 'all'
      response.should be_success
    end
  end

  describe "GET 'filter'" do
    it "returns http success" do
      get 'filter'
      response.should be_success
    end
  end

  describe "GET 'group'" do
    it "returns http success" do
      get 'group'
      response.should be_success
    end
  end

end
