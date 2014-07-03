module Api
  class AuthController < ApplicationController

    def login
      render text: '{"valid":true}', status: 200
    end

  end
end
