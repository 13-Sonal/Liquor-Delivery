module Products
  class Destroy
    attr_accessor :id, :params, :product, :response

    def initialize(params)
      @id = params[:id]
    end

    def call
      find_prod && delete
    end

    def find_prod
      @product = Product.find_by(id: id)
      return true if product

      @response = {
        success: false,
        message:	I18n.t('product.error.not_found')
      }
    end

    def delete
      return response if response

      product.destroy
      @response = {
        success: true,
        message:	I18n.t('product.success.destroy')
      }
    end
  end
end
