module Roles
  class Create
    attr_accessor :params, :response, :role

    def initialize(params)
      @params = params
    end

    def call
      create_role && display
    end

    private

    def create_role
      @role = Role.new(params)
      return true if role.save

      @response = {
        success: false,
        message: role.errors.full_messages
      }
    end

    def display
      @response ||= {
        success: true,
        message: I18n.t('role.success.create'),
        data: role.as_json(except: %i[created_at updated_at])
      }
    end
  end
end
