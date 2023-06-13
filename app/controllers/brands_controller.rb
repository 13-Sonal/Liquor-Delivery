class BrandsController < ApplicationController
  def create
    result = Brands::Create.new(create_params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  def index
    result = Brands::Index.new(params, logged_in_user).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  def show
    result = Brands::Show.new(params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  def update
    result = Brands::Update.new(update_params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  private

  def show_pramas
    params.require(:brand).permit(:name)
  end
  

  def create_params
    params.require(:brand).permit(:name)
  end

  def update_params
    params.require(:brand).permit(:name, :is_active).merge(id: params[:id])
  end
end
