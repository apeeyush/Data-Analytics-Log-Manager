class AuthController < ApplicationController

  def index
	render text: '{"valid":true}', status: 200
  end

end