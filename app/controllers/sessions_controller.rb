class SessionsController < ApplicationController
  protect_from_forgery
  skip_before_action :authenticate_request
  skip_authorize_resource

  def login
    result = Sessions::Login.new(login_params).call
    render json: result
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
