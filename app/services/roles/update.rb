module Roles
	class Update
		attr_accessor :params, :response, :role, :id
		def initialize(params)

			@params = params.except(params[:id]) 
			@id = params[:id]
			
		end
		def call
			find_id && update && set_response
			
		end
		

		def find_id
			@role = Role.find_by(id: id)
			return true if role

			@response = I18n.t('role.error.update')
			
		end

		def update
			return response if response
			role.update(params)
			return true if role.save
			@response = role.errors.full_messages

		end
		
		def set_response
			return response if response
			@response = I18n.t('role.success.update')
		end
		
	end

end
