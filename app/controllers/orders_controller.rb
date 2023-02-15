class OrdersController < ApplicationController

	def create
		result = Orders::Create.new(create_params).call
	end	

	def create_params
		params.require(:order).permit(:quantity).merge(brand_id: params[:brand_id],
			product_id: params[:product_id], user_id: params[:user_id])
	end
	
end
