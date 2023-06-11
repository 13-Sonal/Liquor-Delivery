module Roles
  class Index
    attr_accessor :response, :roles

    def initialize(params)
      @params = params
    end

    def call
      fetch_roles && set_response
    end
    
    private

    def fetch_roles
      @roles = Role.all
      return true if roles.present?

      @response = {
        success: false,
        message: I18n.t('role.error.not_found')
      }
    end

    def set_response
      @response ||= {
        success: true,
        message: I18n.t('role.success.index'),
        data: roles.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
