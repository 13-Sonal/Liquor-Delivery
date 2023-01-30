module Products
	class Create
		attr_accessor :params, :response, :product

		def initialize(params)

			@params = params
			
		end
		def call
		save && display
		end	
		def save
			product = Product.new(params)
			return true if product.save
			@response = product.errors.full_messages
		end

		def display
			return response if response
			@resources = I18n.t('role.success.create')
			
		end
		
	end
	
end