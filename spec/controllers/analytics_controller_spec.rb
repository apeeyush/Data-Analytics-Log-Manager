require 'spec_helper'

describe AnalyticsController, :type => :controller do

  describe "GET 'index'" do
    it "redirects without sign_in" do
      get 'index'
      expect(response.code).to eq("302")
      expect(response).to redirect_to('/users/sign_in')
    end
  end

  describe "GET 'all'" do
    it "redirects without sign_in" do
      get 'all'
      expect(response.code).to eq("302")
      expect(response).to redirect_to('/users/sign_in')
    end
  end

  describe "GET 'filter'" do
    it "redirects without sign_in" do
      get 'filter'
      expect(response.code).to eq("302")
      expect(response).to redirect_to('/users/sign_in')
    end
  end

  describe "GET 'group'" do
    it "redirects without sign_in" do
      get 'group'
      expect(response.code).to eq("302")
      expect(response).to redirect_to('/users/sign_in')
    end
  end

end
