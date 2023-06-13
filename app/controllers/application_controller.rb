# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include JsonWebToken
  before_action :authenticate_request
  authorize_resource
  protect_from_forgery

  attr_accessor :current_user

  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from CanCan::AccessDenied do |exception|
    render json: { message: exception.message, authorization_failure: true }, status: :unauthorized
  end

  def handle_parameter_missing(_exception)
    render json: { error: I18n.t('params_missing') }, status: :bad_request
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

        render_error(I18n.t('user.error.not_found'))

      elsif token_decoded[:error]
        render_error(token_decoded[:message])
      end
    else
      render_error(I18n.t('authorization.failure'))
    end
  end

  def render_error(message)
    render json: {
      success: false,
      message: message
    }, status: :unauthorized
  end
end
