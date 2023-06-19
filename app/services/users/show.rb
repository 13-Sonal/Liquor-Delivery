module Users
  class Show
    attr_accessor :params, :id, :user, :response

    def initialize(params)
      @id = params[:id]
    end

    def call
      find_user && display
    end
   
    private
    
    def find_user
      @user = User.find_by(id: id)
      return true if user

      @response = {
        success: false,
        message: I18n.t('user.error.not_found')
      }
    end

    def display
      @response ||= {
        success: true,
        message: I18n.t('user.success.show'),
        data: user.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
