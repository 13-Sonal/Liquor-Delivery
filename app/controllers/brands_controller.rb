class BrandsController < ApplicationController 
	protect_from_forgery
	def create
		result = Brands::Create.new(create_params,logged_in_user).call
		result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
	end

	def create_params
		params.require(:brand).permit(:name, :key)
	end	

	def index
		result = Brands::Index.new(params).call
		result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
	end

	def show
		result = Brands::Show.new(params).call
		result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
	end

	def update
		result = Brands::Update.new(update_params,logged_in_user).call
		result[:success] ? (render json: result) : (render json: 
			result, status: :unprocessable_entity)
	end

	def update_params
		params.require(:brand).permit(:name, :key).merge(id: params[:id])
	end

	def destroy
		result = Brands::Destroy.new(delete_brand,logged_in_user).call
		result[:success] ? (render json: result) : (render json: result,
      status: :unprocessable_entity)
	end

	def delete_brand
		params.merge(id: params[:id])
	end
	
end
