require 'rails_helper'

RSpec.describe DataInteractiveController, :type => :controller do

  describe "GET 'index'" do
    it "redirects without sign_in" do
      get 'index'
      expect(response.code).to eq("302")
      expect(response).to redirect_to('/users/sign_in')
    end
  end

end
