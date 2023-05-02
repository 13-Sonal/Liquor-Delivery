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
			@response = {
				success: false, 
				message: I18n.t('user.error.not_found')
			}
			
		end
		
		def update
			return response if response
			return true if user.update(params)
			@response = {
				success: false, 
				message: user.errors.full_messages
			}
		end

		def set_response
			
			return response if response
			@response = {
				success: true, 
				message: I18n.t('user.success.update'),
				data: user.as_json(except:[:id, :created_at, :updated_at, :id, :password])

			}
			end
		
	end
end