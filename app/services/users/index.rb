module Users
  class Index
    attr_accessor :response, :users

    def initialize(params)
      @params = params
    end

    def call
      fetch_user && set_response
    end

    private
    def fetch_user
      @users = User.all
      return true if users.present?

      @response = {
        success: false,
        message: I18n.t('user.error.not_found')
      }
    end

    def set_response
      @response ||= {
        success: true,
        message: I18n.t('user.success.index'),
        data: users.as_json(except: %i[id created_at updated_at password])
      }
    end
  end
end
