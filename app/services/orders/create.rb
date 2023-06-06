module Orders
  class Create
    attr_accessor :product_orders, :order, :total_quantity,
                  :bill_value, :current_user, :response

    def initialize(params, current_user)
      @product_orders = params[:order][:products]
      @current_user = current_user
      @total_quantity = 0
      @bill_value = 0
    end

    def call
      create_order && link_products && update_bill_quantity && set_response
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
      ActiveRecord::Base.transaction do
        product_orders.each do |product_order_params|
          if find_product(product_order_params[:product_id]).present?
            product_order = ProductOrder.new(
              product_id: product_order_params[:product_id],
              order_id: order.id,
              items: product_order_params[:items],
              accumulated_price: (@product.price.to_i *
                product_order_params[:items].to_i)
            )
            product_order.save
          else
            @response = {
              success: false,
              message: I18n.t('product_order.error.place')
            }
          end
        end
      end
    end

    def update_bill_quantity
      return response if response

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

    def find_product(product_id)
      @product = Product.find_by(id: product_id)
      if @product
        true
      else
        false
      end
    end
  end
end
