module Brands

	class Update
	  attr_accessor :update_params, :response, :brand, :id
		def initialize(params)
			byebug 
			@update_params = params.except(:id)
			@id = params[:id]
		end

		def call
		brands_exist && update && set_response
		end	
		
		def brands_exist
			@brand = Brand.find_by(id: id)
			byebug
			return true if brand
			@response = {
				success: false, 
				message: I18n.t('brand.error.not_found')
			}
		end

		def update
			return response if response
			return true if brand.update(update_params)
			@response = {
				success: false, 
				message: brand.errors.full_messages
			}
		end


		def set_response
			return response if response
			@response = {
				success: true, 
				message: I18n.t('brand.success.update'),
				data: brand.as_json(except: [:id, :created_at, :updated_at])
			}
		end
	end	
end