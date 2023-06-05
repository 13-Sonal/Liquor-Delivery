module Brands
  class Index < Base
    attr_accessor :response, :brand, :current_user

    def initialize(params, current_user)
      @current_user = current_user
      @params = params
    end

    def call
      fetch_brands && set_response
    end

    def fetch_brands
      if current_user.is_supplier? || current_user.is_admin?
        @brand = Brand.all
        return true if brand.present?

      elsif current_user.is_customer?

        @brand = Brand.active
        true
      else
        @response = {
          success: false,
          message: I18n.t('brand.error.not_found')
        }
      end
    end

    def set_response
      return response if response

      @response = {
        success: true,
        message: I18n.t('brand.success.index'),
        count: brand.count,
        data: brand.as_json(except: %i[id created_at updated_at])
      }
    end
  end
end
