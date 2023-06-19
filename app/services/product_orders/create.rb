module ProductOrders
  class Create
    attr_accessor :product, :product_order_params, :response, :product_id,
                  :params, :product_order, :order_id

    def initialize(params, order_id)
      @order_id = order_id
      @params = params
      @product_id = params[:product_id]
      @product_order_params = {}
    end

    def call
      find_product && check_available_stock && set_product_params && create_product_orders
    end

    def find_product
      @product = Product.find_by(id: product_id)

      return true if product

      @response = {
        success: false,
        message: I18n.t('product.error.not_found')
      }
    end

    def check_available_stock
      return response if response
      return true if (product.stock.to_i >= params[:items].to_i)
      byebug
      @response = {
        success: false,
        message: I18n.t('product_order.error.insufficient_stock' , name: product.name,
                                                                   id: product.id)
      }
    end
    

    def set_product_params
      return response if response

      @product_order_params = {
        product_id: product.id,
        order_id: order_id,
        items: params[:items],
        accumulated_price: (product.price.to_i * params[:items].to_i)
        }        
    end

    def create_product_orders
      return response if response

      @product_order = ProductOrder.new(product_order_params)
      
      if product_order.save
      success_response = {
        success: true,
        accumulated_price: product_order.accumulated_price,
        items: product_order.items
      }
      else
        false
      end
    end
  end
end
