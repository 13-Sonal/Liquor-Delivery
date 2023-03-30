module Products
	class Create
		attr_accessor :product_params, :params, :response,
     :product, :brand_id, :brand, :brand_pro, :qty, :price


		def initialize(params)
      byebug
      @product_params = params
      byebug
      @brand_id = params[:brand_id]
		end

    def call
      find_brand && create_product && display 
    end

    def find_brand
      @brand= Brand.find_by(id: brand_id)
      byebug
      return true if brand
      @response = {
        success: false, 
        message: I18n.t('brand.error.not_found')
      }

    end
		
    def create_product
      byebug
      return response if response
			byebug
      @product = Product.new(product_params)
			return true if product.save
      byebug
			@response = {
        success: false, 
        message: product.errors.full_messages
      }
		end

    # def create_brand_products
    #   return response if response
    #   byebug
    #   @brand_pro = BrandProduct.new(
    #     brand_id: brand.id,
    #     product_id: product.id,
    #     quantity: qty,
    #     price: price
    #   )
    #   byebug
    #   return true if brand_pro.save
    #   @response = {
    #     success: false, 
    #     message: brand_pro.errors.full_messages
    #   }
    # end
    


		def display
			return response if response
			@reponse = {
        success: true, 
        message: I18n.t('product.success.create'),
        data: product.as_json(except: [:created_at, :updated_at])
      }
		end
		
	end
	
end
