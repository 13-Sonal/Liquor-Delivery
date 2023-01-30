class ProductsController < ApplicationController
  protect_from_forgery
	def create
    byebug
		result = Products::Create.new(create_params).call
		render json: result

	end	

	def create_params
		params.require(:product).permit(:quantity, :name, :price)
	end	


end	