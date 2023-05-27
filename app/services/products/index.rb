module Products
	class Index < Base
		
		attr_accessor :params, :response, :product
		def initialize(params)
			@params = params
		end

		def call
			find_products && display
		end
		
		def find_products
			@product = Product.active_brands
			return true if product.present?
			@response = {
				success: false,
				message: I18n.t('product.error.not_found')
			}
		end

		def display
			return response if response
			@response = {
				success: true, 
				message: I18n.t('product.success.index'),
				data: product.as_json(except: [:id, :created_at, :updated_at])
			}
		end
	end
end