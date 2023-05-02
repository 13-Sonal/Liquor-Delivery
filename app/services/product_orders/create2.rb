module ProductOrders
  class Create

    attr_accessor :order_id, :product_orders, :response
    
    def initailize(product_orders, order_id)
      @product_id = product_orders[params]product_id[]
      @order_id = order_id
    end

    def fetch_product
      @product = Product.find_by(id: product_id)
      return true if product

      @response = {
        success: false, 
        message: Ii8n.t('product.error.not_found')
      }
    end

    def create_order_products
      return response if response
      @product_order_params[:product_id] = product.id
      @product_order_params[:order_id] = order_id
      @product_order_params[:items] = params[:items]
      @product_order_params[:accumulated_price] = (product.price.to_i *
        params[:items].to_i)
    end
    
    
    
  end
end