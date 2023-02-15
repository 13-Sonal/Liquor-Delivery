module Brands
  class Create < Base
   attr_accessor :params, :brand_name, :response, :brand

    def initialize(params)
      byebug
      @params = params   
    end

    def call
      save && display
    end

    def save
      @brand= Brand.new(params)
      return true if brand.save

      @response = {
        success: false, 
        message: brand.errors.full_messages
      }
    end
    
    def display
      return response if response

      byebug
      @response = {
        success: true, 
        message: I18n.t('brand.success.create'),
        data: brand.as_json(except: [:created_at, :updated_at, :id])
      }
    end
  end
end
