class ApplicationController < ActionController::Base
  include JsonWebToken
  before_action :authenticate_request
  authorize_resource

  attr_accessor :current_user

  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message, authorization_failure: true }, status: :unauthorized
  end

  def handle_parameter_missing(exception)
    render json: { esrror: exception.message }, status: :bad_request
  end

  def logged_in_user
    current_user ||= @current_user
  end

  private

  def authenticate_request
    token = request.headers['Authorization']
    if token
      token_decoded = jwt_decode(token)
      if token_decoded[:user_id].present?
        @current_user = User.find_by(id: token_decoded[:user_id])
        return true if @current_user

        render json: {
          success: false,
          message: I18n.t('user.error.not_found')
        }
      elsif token_decoded[:error]
        render json: {
                 success: false,
                 message: token_decoded[:message]
               },
               status: :unauthorized
      end
    else
      render json: {
               success: false,
               message: I18n.t('authorization.failure')
             },
             status: :unauthorized
    end
  end
end
