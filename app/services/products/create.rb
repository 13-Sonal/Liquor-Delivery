module Products
  class Create
    attr_accessor :product_params, :params, :response,
                  :product, :brand_id, :brand

    def initialize(params)
      @product_params = params
      @brand_id = params[:brand_id]
    end

    def call
      find_brand && create_product && display
    end

    private

    def find_brand
      @brand = Brand.find_by(id: brand_id)
      return true if brand

      @response = {
        success: false,
        message: I18n.t('brand.error.not_found')
      }
    end

    def create_product
      return response if response

      @product = Product.new(product_params)
      return true if product.save

      @response = {
        success: false,
        message: product.errors.full_messages
      }
    end

    def display   
      @response ||={
        success: true,
        message: I18n.t('product.success.create'),
        brand: product.brand.name,
        data: product.as_json(except: %i[id brand_id created_at updated_at])
      }
    end
  end
end
