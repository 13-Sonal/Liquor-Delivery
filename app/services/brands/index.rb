module Brands
  class Index
    attr_accessor :response, :brands, :current_user

    def initialize(params, current_user)
      @current_user = current_user
      @params = params
    end

    def call
      fetch_brands && set_response
    end

    def fetch_brands
      if current_user.is_supplier? || current_user.is_admin?
        @brands = Brand.all
        return true if brands
        
      elsif current_user.is_customer?
        @brands = Brand.active
        true
      else
        @response = {
          success: false,
          message: I18n.t('brand.error.not_found')
        }
      end
    end

    def set_response

      @response ||= {
        success: true,
        message: I18n.t('brand.success.index'),
        count: brands.count,
        data: brands.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
