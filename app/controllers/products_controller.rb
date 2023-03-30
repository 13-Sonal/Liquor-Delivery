class ProductsController < ApplicationController
  protect_from_forgery
	def create
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
    params.require(:product).permit(:quantity, :name,
      :price, :stock).merge(product_id: params[:id] )
  end
  
	def create_params
		params.require(:product).permit(:name, :price,
      :stock).merge(brand_id: params[:id])
	end
end	
