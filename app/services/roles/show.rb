module Roles
  class Show < Base
    attr_accessor :params, :id, :role, :response

    def initialize(params)
      @id = params[:id]
    end

    def call
      find_id && display
    end

    def find_id
      @role = Role.find_by(id: id)
      byebug
      return true if role

      @response = {
        success: false,
        message: I18n.t('role.error.not_found')
      }
    end

    def display
      return response if response

      @response = {
        success: true,
        message: I18n.t('role.success.show'),
        data: role.as_json(except: [:id, :created_at, :updated_at])
      }
    end
  end
end