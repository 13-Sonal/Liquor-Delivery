module Roles
  class Update
    attr_accessor :params, :response, :role, :id, :current_user

    def initialize(params, _current_user)
      @params = params.except(params[:id])
      @id = params[:id]
    end

    def call
      fetch_role && update && set_response
    end

    def fetch_role
      @role = Role.find_by(id: id)
      return true if role

      @response = {
        success: false,
        message: I18n.t('role.error.update')
      }
    end

    def update
      return response if response
      return true if @role.update(params)

      @response = role.errors.full_messages
    end

    def set_response
      @response ||= {
        success: true,
        message: I18n.t('role.success.update'),
        data: role.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
