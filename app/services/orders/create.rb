module Orders
	class Create < Base
		
		def initialize
			@brand_id = params[:brand_id]
			@product_id = params[:product_id]
			@user_id = params[:user_id]
			@quantity = params[:quantity]
		end

		def find_brand_product
			@brand_product = BrandProduct.find_by(brand_id: brand_id, product_id: product_id)
			return response if brand_product
			@response = {
				success: false, 
				message: I18n.t('order.error.not_found')
			}
		end

		def place_order
			
      return response if response
			byebug
      @order = Order.new(quantity)
			return true if order.save
      byebug
			@response = {
        success: false, 
        message: product.errors.full_messages
      }

		end

		def product_orders
			return response if response
      byebug
      @productOrders = ProductOrder.new(
        order_id: order.id,
        product_id: product.id,
        status: 'approved'
			)
      return true if productOrders.save
			@response = {
				success: false, 
				message: I18n.t('order.error.create')
			}  
			
		end
		
		def set_response
			return response if response
			@response = {
				success: true, 
				message: I18n.t('order')
			}
		end
		
		
		
	end
	
end