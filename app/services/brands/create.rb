module Brands
  class Create < Base
   attr_accessor :params, :brand_name, :response, :brand, :current_user

    def initialize(params, current_user)
      @current_user = current_user
      @params = params   
    end

    def call
      check_access && save && display
    end

    def check_access
      return true if (current_user.is_admin? || current_user.is_supplier?) 
      @response =
      {
        success: false, 
        message: "Access Denied"
      } 
    end
  
    def save
      return response if response
      @brand= Brand.new(params)
      return true if brand.save

      @response = {
        success: false, 
        message: brand.errors.full_messages
      }
    end
    
    def display
      return response if response

      @response = {
        success: true, 
        message: I18n.t('brand.success.create'),
        data: brand.as_json(except: [:created_at, :updated_at, :id, :is_active])
      }
    end
  end
end
