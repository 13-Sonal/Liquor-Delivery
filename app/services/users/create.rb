module Users
	class Create < Base
		attr_accessor :params, :response
		def initialize(params)

			@params = params
			
		end

		def call
			save && display
		end
		

		def save
			user = User.new(params)
			return true if user.save

			@response = user.errors.full_messages
		end
		
		def display
			return response if response
			@response = I18n.t('user.success.create')
		end
		
		
	end   
    
end