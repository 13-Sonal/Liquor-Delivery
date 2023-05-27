module Brands
  class Deactivate
		attr_accessor :brand, :response, :id,:current_user
	
		def initialize(params,current_user)
			@id = params[:id]
			@current_user = current_user
		end

		def check_access
			return true if (current_user.is_admin? || current_user.is_supplier?) 
			@response = 
			{
				success: false, 
				message: "Access Denied"
			}
	  end
		
		def call
			find_brand && brand_deactivate
		end
		
		def find_brand
			@brand = Brand.find_by(id: id)
			return true if brand

			@response = {
				success: false, 
				message: I18n.t('brand.error.not_found')
			}
		end

		def brand_deactivate
			return response if response
			brand.update(is_active: "false")
			@response = {
				success: true, 
				message: I18n.t('brand.success.destroy')
			}
		end
	end
end
