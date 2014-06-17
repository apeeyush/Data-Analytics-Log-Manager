require 'spec_helper'

describe AnalyticsController, :type => :controller do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'all'" do
    it "returns http success" do
      get 'all'
      expect(response).to be_success
    end
  end

  describe "GET 'filter'" do
    it "returns http success" do
      get 'filter'
      expect(response).to be_success
    end
  end

  describe "GET 'group'" do
    it "returns http success" do
      get 'group'
      expect(response).to be_success
    end
  end

end
