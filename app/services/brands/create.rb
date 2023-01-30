module Brands
  class Create < Base
   attr_accessor :params, :brand_name, :response

    def initialize(params)
      byebug
      @params = params   
    end

    def call
      save && display
    end

    def save
      brand= Brand.new(params)
      return true if brand.save

      @response = brand.errors.full_messages
    end
    
    def display
      return response if response

      @response = I18n.t('brand.success.create')
  
    end
  end
end
