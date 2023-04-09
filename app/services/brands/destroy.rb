module Brands
  class Destroy
		attr_accessor :brand, :response, :id
	

		def initialize(params)
			@id = params[:id]
		end
		
		def call
			find_brand && delete
		end
		
		def find_brand
			byebug
			@brand = Brand.find_by(id: id)
			byebug
			return true if brand

			@response = {
				success: false, 
				message: I18n.t('brand.error.not_found')
			}
		end

		def delete
			return response if response
			brand.destroy
			@response = {
				success: true, 
				message: I18n.t('brand.success.destroy')
			}

		end
		
		
		
	end
	
end