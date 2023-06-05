module Products
  class Index < Base
    attr_accessor :params, :response, :product, :current_user

    def initialize(params, current_user)
      @params = params
      @current_user = current_user
    end

    def call
      find_products && display_products
    end

    def find_products
      if current_user.is_supplier? || current_user.is_admin?
        @product = Product.all
        return true if product

      elsif current_user.is_customer?
        @product = Product.active_brands
        return true if product
      else
        @response = {
          success: false,
          message: I18n.t('product.error.not_found')
        }
      end
    end

    def display_products
      return response if response

      @response = {
        success: true,
        count: product.count,
        message: I18n.t('product.success.index'),
        data: product.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
