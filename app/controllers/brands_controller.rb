class BrandsController < ApplicationController 
	protect_from_forgery

	def create
		result = Brands::Create.new(create_params).call
		render json: result
	end

	def create_params
		byebug
		params.require(:brand).permit(:name, :key)
	end	

	def index
		render json: Brand.all
	end
	
	def update
		byebug
		result = Brands::Update.new(update_params).call
		render json: result
	end

	def update_params
		byebug
		params.require(:brand).permit(:name, :key).merge(id: params[:id])
	end

	def destroy
		byebug
		result = Brands::Destroy.new(delete_brand).call
		render json: result

	end

	def delete_brand
		params.merge(id: params[:id])
	end
	
end
