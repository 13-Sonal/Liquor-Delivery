module Products
  class Show
		
		attr_accessor :params, :response, :product

		def initialize(params)
			@params = params
			
		end
		def call
			find_prod && show
		end
		
		def find_prod
			@product = Product.find_by(id: params[:id])
			return true if product && product.brand.is_active
			@response = {
				success: false,
				message: I18n.t('product.error.not_found')
			}
		end

		def show
			return response if response
			@response = {
				success: true, 
				message: I18n.t('product.success.show'),
				data: product.as_json(except: [:id, :created_at, :updated_at])
			}
			
		end
	end	
end