module Products
  class Show
    attr_accessor :params, :response, :product, :current_user

    def initialize(params, current_user)
      @params = params
      @current_user = current_user
    end

    def call
      find_product && check_access && show
    end

    def find_product
      @product = Product.find_by(id: params[:id])
      return true if product

      @response = {
        success: false,
        message: I18n.t('product.error.not_found')
      }
    end

    def check_access
      return response if response

      if current_user.is_admin? || current_user.is_supplier?
        true

      elsif current_user.is_customer?
        return true if product.brand.is_active

        @response = {
          success: false,
          message: I18n.t('product.error.not_found')
        }
      end
    end

    def show
      @response ||= {
        success: true,
        message: I18n.t('product.success.show'),
        data: product.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
