module Products
	class Create
		attr_accessor :product_params, :params, :response,
     :product, :brand_id, :brand, :brand_pro, :qty, :price


		def initialize(params)
      @product_params = params
      @brand_id = params[:brand_id]
		end

    def call
      find_brand && create_product && display 
    end

    def find_brand
      @brand= Brand.find_by(id: brand_id)
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

    # def create_brand_products
    #   return response if response
    
    #   @brand_pro = BrandProduct.new(
    #     brand_id: brand.id,
    #     product_id: product.id,
    #     quantity: qty,
    #     price: price
    #   )
    
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
