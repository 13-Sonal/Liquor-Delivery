module ProductOrders
  class Create < Base

    attr_accessor :product, :product_order_params, :response, :product_id,
    :params, :product_order, :order_id

    def initialize(params, order_id)
      byebug
      @order_id = order_id
      @params = params
      @product_id = params[:product_id]
      @product_order_params = {}
      byebug
    end

    def call
      find_product && set_product_params && create_product_orders
    end

    def find_product
      byebug
      @product = Product.find_by(id: product_id)

      return true if product

      @response = {
        success: false, 
        message: I18n.t('product.error.not_found')
      }
    end

    def set_product_params
      return response if response
      byebug
      @product_order_params[:product_id] = product.id
      byebug
      @product_order_params[:order_id] = order_id
      @product_order_params[:items] = params[:items]
      @product_order_params[:accumulated_price] = (product.price.to_i *
        params[:items].to_i)
    end

    def create_product_orders
      return response if response

      @product_order = ProductOrder.new(product_order_params)

      success_response = { 
        success: true,
        accumulated_price: product_order.accumulated_price,
        items: product_order.items,
      }

      if product_order.save
        success_response
        byebug
      else
        false
      end
    end
  end
end
  