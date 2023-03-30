class BrandsController < ApplicationController 
	protect_from_forgery
	def create
		result = Brands::Create.new(create_params).call
		result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
	end

	def create_params
		byebug
		params.require(:brand).permit(:name, :key)
	end	

	def index
    byebug
		result = Brands::Index.new(params).call
		result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
	end

	def show
		result = Brands::Show.new(params).call
		result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
	end

	def update
		byebug
		result = Brands::Update.new(update_params).call
		result[:success] ? (render json: result) : (render json: 
			result, status: :unprocessable_entity)
	end

	def update_params
		byebug
		params.require(:brand).permit(:name, :key).merge(id: params[:id])
	end

	def destroy
		byebug
		result = Brands::Destroy.new(delete_brand).call
		result[:success] ? (render json: result) : (render json: result,
      status: :unprocessable_entity)
	end

	def delete_brand
		params.merge(id: params[:id])
	end
	
end
