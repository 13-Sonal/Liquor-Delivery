module Roles
	class Create < Base
		
		attr_accessor :params,:response
		def initialize(params)
			@params = params
		end

		def call
			save && display
		end
		

		def save
			role = Role.new(params) 
			return true if role.save

			@response = {success: false, 
				message: role.errors.full_messages}
		end

		def display
			return response if response
			@response ={success: true,
				message: I18n.t('role.success.create')}
		
		end	
	end
end
