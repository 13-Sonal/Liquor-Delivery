module Users
	class Create < Base
		attr_accessor :params, :response, :user

		def initialize(params)

			@params = params
			
		end

		def call
			save && display
		end
		

		def save
			@user = User.new(params)
			return true if user.save

			@response = {
				success: false, 
				message: user.errors.full_messages
			}
		end
		
		def display
			return response if response
			token = encode_token({user_id: @user.id})
			@response = {
				success: true, 
				message: I18n.t('user.success.create'),
				data: user.as_json(except: [:id, :created_at, :updated_at, :password]), 
				token: token
			}
		end	
	end       
end
