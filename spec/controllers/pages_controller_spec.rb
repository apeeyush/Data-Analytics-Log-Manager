require 'spec_helper'

describe PagesController, :type => :controller do

  describe "GET 'main'" do
    it "returns http success" do
      get 'main'
      expect(response).to be_success
    end
  end

end
