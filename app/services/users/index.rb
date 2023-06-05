module Users
  class Index < Base
    attr_accessor :response, :user

    def initialize(params)
      @params = params
    end

    def call
      fetch_user && set_response
    end

    def fetch_user
      @user = User.all
      return true if user.present?

      @response = {
        success: false,
        message: I18n.t('user.error.not_found')
      }
    end

    def set_response
      return response if response

      @response = {
        success: true,
        message: I18n.t('user.success.index'),
        data: user.as_json(except: %i[id created_at updated_at password])
      }
    end
  end
end
