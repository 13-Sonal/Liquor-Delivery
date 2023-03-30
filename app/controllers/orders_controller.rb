class OrdersController < ApplicationController
	protect_from_forgery
	def create
		byebug
		result = Orders::Create.new(params, logged_in_user).call
		result[:success] ? (render json: result) : (render json: result,
			status: :unprocessable_entity)
	end
end
