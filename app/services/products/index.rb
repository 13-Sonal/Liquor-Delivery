module Products
  class Index 
    attr_accessor :params, :response, :products, :current_user

    def initialize(params, current_user)
      @params = params
      @current_user = current_user
    end

    def call
      find_products && display_products
    end

    private

    def find_products
      if current_user.is_supplier? || current_user.is_admin?
        @products = Product.all
      elsif current_user.is_customer?
        @products = Product.active_brands
      else
        @response = {
          success: false,
          message: I18n.t('product.error.not_found')
        }
        return false
      end
      products.present?
    end
    
    def display_products
      @response ||= {
        success: true,
        count: products.count,
        message: I18n.t('product.success.index'),
        data: products.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
