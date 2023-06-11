module Brands
  class Show
    attr_accessor :params, :id, :brand, :response,

    def initialize(params)
      @id = params[:id]
    end

    def call
      find_brand && display
    end
    
    def find_brand
      @brand = Brand.find_by(id: id)
      return true if brand

      @response = {
        success: false,
        message: I18n.t('brand.error.not_found')
      }
    end

    def display
      @response ||= {
        success: true,
        message: I18n.t('brand.success.show'),
        data: brand.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
