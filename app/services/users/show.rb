module Users
  class Show < Base
    attr_accessor :params, :id, :user, :response

    def initialize(params)
      @id = params[:id]
    end

    def call
      find_user_id && display
    end

    def find_user_id
      @user = User.find_by(id: id)
      return true if user

      @response = {
        success: false,
        message: I18n.t('user.error.not_found')
      }
    end

    def display
      return response if response

      @response = {
        success: true,
        message: I18n.t('user.success.show'),
        data: user.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
