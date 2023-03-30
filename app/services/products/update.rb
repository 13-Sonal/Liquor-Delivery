module Products
	class Update < Base
		
		attr_accessor :update_brand_products, :brand_id, :product_id,
		:response, :brand_product, :product, :brand

		def initialize(params)
			@update_brand_products = params.slice(:price, :stock, :name)
			byebug
			@product_id = params[:product_id]
		end

		def call
			find_product && update_key && set_response
		end

		def find_product
			byebug
			return response if response
			@product = Product.find_by(id: product_id)
			return true if product
			@response = {
				success: false,
				message: I18n.t('product.error.not_found')
			}
		end

		# def create_brand_product
		# 	return response if response
		# 	byebug
		# 	@brand_product = BrandProduct.new(
		# 		brand_id: brand.id,
		# 		product_id: product.id
		# 	)
		# 	return true if brand_product
		# 	@response = {
		# 		success: false,
		# 		message: I18n.t('brand_product.error.not_found')
		# 	}
		# end

		def update_key
			byebug
			return response if response
			return true if product.update(update_brand_products)
			@response = {
				success: false, 
				message: product.errors.full_messages
      }
		end

		def set_response
			return response if response
			@response = {
				success: true,
				message: I18n.t('product.success.update'),
				data: product.as_json(except: [:created_at, :updated_at])
			}
		end
	end
end
