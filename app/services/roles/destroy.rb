module Roles
	class Destroy
		attr_accessor :id, :response, :role
		def initialize(params)
			@id = params[:id]
			byebug
		end
		
		def call
			find_role && delete
		end
		
		def find_role
			byebug
			role = Role.find_by(id: id)
			byebug
			return true if role
			@response = {
				success: false, 
				message: I18n.t('role.error.not_found')
			}
		end

		def delete
			return response if response
			byebug
			role.destroy
			@response = {
				success: true,
			  message: I18n.t('role.success.destroy')
			}
			byebug

		end

		
		
	end
end
