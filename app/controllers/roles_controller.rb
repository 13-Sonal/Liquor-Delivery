class RolesController < ApplicationController

  def create
    result = Roles::Create.new(create_params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  def index
    result = Roles::Index.new(params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  def show
    result = Roles::Show.new(params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  def update
    result = Roles::Update.new(update_params).call
    render json: result
  end

  private

  def update_params
    params.require(:role).permit(:name, :key).merge(id: params[:id])
  end

  def create_params
    params.require(:role).permit(:name, :key)
  end
end
