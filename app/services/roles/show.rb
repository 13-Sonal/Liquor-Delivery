module Roles
  class Show
    attr_accessor :params, :id, :role, :response

    def initialize(params)
      @id = params[:id]
    end

    def call
      fetch_role && display
    end

    private
    
    def fetch_role
      @role = Role.find_by(id: id)
      return true if role

      @response = {
        success: false,
        message: I18n.t('role.error.not_found')
      }
    end

    def display
      @response ||= {
        success: true,
        message: I18n.t('role.success.show'),
        data: role.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
