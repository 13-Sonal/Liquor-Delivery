class UsersController < ApplicationController
  protect_from_forgery

  def create
    result = Users::Create.new(create_params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end  

  def create_params
    params.require(:user).permit(:first_name,
      :last_name, :contact_number, :email_id, :role_id, :password)
  end
  def index
    result = Users::Index.new(params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)

  end
  def show
    result = Users::Show.new(params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)

  end
  
  

  def destroy
    byebug
    result = Users::Destroy.new(params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  def update
    result = Users::Update.new(updated_params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  def updated_params
    create_params.merge(id: params[:id])
  end
end