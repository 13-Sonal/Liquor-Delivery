module Users
  class Create
    attr_accessor :params, :response, :user

    def initialize(params)
      @params = params
    end

    def call
      save && display
    end

    def save
      @user = User.new(params)
      return true if user.save

      @response = {
        success: false,
        message: user.errors.full_messages
      }
    end

    def display
      
      @response ||= {
        success: true,
        message: I18n.t('user.success.create'),
        data: user.as_json(except: %i[id created_at updated_at password])
      }
    end
  end
end
