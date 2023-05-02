module Orders

  class Create < Base
    
    attr_accessor :params, :logged_in_user, :order

    def initialize(params, logged_in_user)
      @params = params
      @logged_in_user = current_user
      @product_orders = params[:order][:products]
      @total_quantity = 0
      @bill_value = 0
    end

    def create_order
      @order = Order.new(id: current_user.id)
      return true if order.save
      @response = {
        success: false, 
        message: I18n.t('order.error.not_found')
      }
    end

    def create_products_order
      return response if response
      product_orders.each do |product_order_params|
      result = ProductOrders::Create(product_orders, order.id)
    
    end
    
    
    
  end
  
end