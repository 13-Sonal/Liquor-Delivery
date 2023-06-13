module Sessions
  class Login
    include JsonWebToken
    attr_accessor :user, :email, :password, :token, :response

    def initialize(params)
      @email = params[:email]
      @password = params[:password]
    end

    def call
      find_user && validate_password &&
        generate_token && set_response
    end

    private

    def find_user
      @user = User.find_by(email_id: email)
      return true if user

      @response = {
        success: false,
        message: I18n.t('user.error.email')
      }
    end

    def validate_password
      return response if response
      return true if password == user.password

      @response = {
        success: false,
        message: I18n.t('user.error.password')
      }
    end

    def generate_token
      return response if response
      # will generate token here
      @token = jwt_encode(user_id: user.id)
      return true if token
      @response = I18n.t('user.error.token_not_generated')
    end

    def set_response
      
      @response ||= {
        success: true,
        data: user.as_json,
        token: token
      }
    end
  end
end
