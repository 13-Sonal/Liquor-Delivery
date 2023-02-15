
class ApplicationController < ActionController::Base
  # attr_accessor :current_user
  include JsonWebToken
  before_action :authenticate_request  
  
  def logged_in_user
    current_user ||= @current_user
  end
  
  private  

  def authenticate_request
     token = request.headers["Authorization"]
     byebug
		 if token
      byebug
		  token_decoded = jwt_decode(token)
      if token_decoded[:user_id].present?
        @current_user=User.find_by(id: token_decoded[:user_id]) 
        return true if @current_user
        render json: {
          success: false, 
          message: I18n.t('user.error.not_found')
        }
      byebug
      elsif token_decoded[:error]
        byebug
         render json:  {
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
