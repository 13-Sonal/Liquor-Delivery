class ProductsController < ApplicationController
  protect_from_forgery
	def create
    byebug
		result = Products::Create.new(create_params).call
    byebug
		result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
	end

  def update
    result = Products::Update.new(update_params).call
		result[:success] ? (render json: result) : (render json:
			result, status: :unprocessable_entity)
  end

  def update_params
    params.require(:brand_products).permit(:quantity, :name,
      :price).merge(brand_id: params[:brand_id], product_id: params[:product_id] )
  end
  
	def create_params
		params.require(:product).permit(:quantity, :name,
      :brand_id, :price)
	end
end	
