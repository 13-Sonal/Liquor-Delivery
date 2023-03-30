module Orders
	class Create < Base
		attr_accessor :product_orders, :order, :total_quantity,
		:bill_value, :current_user, :response

		def initialize(params, current_user)
			@product_orders = params[:order][:products]
			@current_user = current_user
			@total_quantity = 0
			@bill_value = 0
		end

		def call
			create_order && link_products && qty_bill_update && set_response 
		end

		def create_order
			@order = Order.new(user_id: current_user.id)

			return true if order.save

			@response = {
				success: false, 
				message: order.errors.full_messages
			}
		end 
		
		def link_products
			product_orders.each do |product_order_params|
				result = ProductOrders::Create.new(product_order_params, order.id).call
				byebug
				if result[:success] == true
					@total_quantity += result[:items].to_i
					@bill_value += result[:accumulated_price].to_i
					byebug
				else 
					@response= {
						success: false, 
						message: I18n.t('product_order.error.place')
					}
					break
				end
			end
		end

		def qty_bill_update
			return response if response
      byebug
			return true if order.update(total_quantity: total_quantity,
				bill_value: bill_value)

			@response = {
				success: false, 
				message: order.errors.full_messages
			}	
		end
		

		def set_response
			return response if response
			@response = {
				success: true, 
				message: I18n.t('order.success.create')
			}
		end
	end
end
