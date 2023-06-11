module Brands
  class Create
    attr_accessor :params, :brand_name, :response, :brand

    def initialize(params)
      @params = params
    end

    def call
      create_brand && display_brand
    end

    private

    def create_brand
      @brand = Brand.new(params)
      return true if brand.save

      @response = {
        success: false,
        message: brand.errors.full_messages
      }
    end

    def display_brand
      @response ||= {
        success: true,
        message: I18n.t('brand.success.create'),
        data: brand.as_json(except: %i[created_at updated_at id is_active])
      }
    end
  end
end
