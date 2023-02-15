module Brands
	class Index < Base
		attr_accessor :response, :brand
		
		def initialize(params)
			@params = params
		end
		def call
			fetch_brands && set_response
		end
		
		def fetch_brands
			@brand = Brand.all
			return true if brand.present?
			@response = {
				success: false, 
				message: I18n.t('brand.error.not_found')
			}
		end
		def set_response
			return response if response
			@response = {
				success: true, 
				message: I18n.t('brand.success.index'),
				data: brand.as_json(except: [:id, :created_at, :updated_at])
			}
		end
	end
    
end
