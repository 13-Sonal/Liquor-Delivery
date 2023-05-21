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
			return response if response
			@response = {
				success: true, 
				message: I18n.t('role.success.update'), 
				data: role.as_json(except:[:id, :created_at, :updated_at])
			}	
		end
	end
end
