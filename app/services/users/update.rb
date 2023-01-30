module Users
	class Update < Base
		attr_accessor :params, :id, :user, :response

		def initialize(params)

			@params = params.except(params[:id]) 
			@id = params[:id]
		end

		def call
			find_id && update && set_response
		end
		

		def find_id
			@user = User.find_by(id: id)
			return true if user
			@response = I18n.t('user.error.update')
			
		end
		
		def update
			return response if response
			return true if user.save
			@response = user.errors.full_messages
		end

		def set_response
			return response if response
			@response = I18n.t('user.success.update')
		end
		
	end
end