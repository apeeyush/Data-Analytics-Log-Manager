module Api
  class AuthController < ApplicationController
    before_filter :ensure_params_exist
    respond_to :json

    def login
      resource = User.find_for_database_authentication(:email=>params[:username])
      return invalid_login_attempt unless resource
      if resource.valid_password?(params[:password])
        render :json=> {:valid=>true, :email=>resource.email}
        return
      end
      invalid_login_attempt
    end

  protected
  def ensure_params_exist
    return unless params[:username].blank?
    render :json=>{:success=>false, :message=>"missing username parameter"}, :status=>422
  end
 
  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end

  end
end
