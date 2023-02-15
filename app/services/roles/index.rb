module Roles
	class Index < Base
		attr_accessor :response, :role
		
		def initialize(params)
			@params = params
		end
		def call
			fetch_role && set_response
		end
		
		def fetch_role
			@role = Role.all
			return true if role.present?
			@response = {
				success: false, 
				message: I18n.t('role.error.not_found')
			}
		end
		def set_response
			return response if response
			@response = {
				success: true, 
				message: I18n.t('role.success.index'),
				data: role.as_json(except: [:id, :created_at, :updated_at])
			}
		end
	end
    
end
