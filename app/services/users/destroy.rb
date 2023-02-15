module Users
	
	class Destroy < Base
		attr_accessor :id, :user, :response
 
		def initialize(params)
			byebug
			@id = params[:id]
			byebug
		end

		def call
			find_user && destroy
		end
		

		def find_user
			@user = User.find_by(id: id)
			return true if user
			@response = {
			success: false,
			message:	I18n.t('user.error.not_found')
			}
		end

		def destroy
			return response if response
			user.destroy
			@response = {
				success: true,
				message: I18n.t('user.success.destroy')
				}
			
		end
		
		
		
	end
end