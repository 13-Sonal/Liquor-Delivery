module Roles
  class Create < Base
    attr_accessor :params, :response, :role

    def initialize(params)
      @params = params
    end

    def call
      save && display
    end

    def save
      @role = Role.new(params)
      return true if role.save

      @response = {
        success: false,
        message: role.errors.full_messages
      }
    end

    def display
      return response if response

      @response = {
        success: true,
        message: I18n.t('role.success.create'),
        data: role.as_json(except: %i[created_at updated_at])
      }
    end
  end
end
