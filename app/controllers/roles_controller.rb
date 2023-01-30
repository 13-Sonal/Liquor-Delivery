class RolesController < ApplicationController
  protect_from_forgery

  def create
  result = Roles::Create.new(create_params).call
  result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end  

  def create_params
    byebug
    params.require(:role).permit(:name, :key)
  end

  def index
    render json: Role.all
  end

  def destroy
    result = Roles::Destroy.new(delete_role).call
    render json: result

  end

  def delete_role
    params.merge(id: params[:id])
  end
  
  

  def update
    result = Roles::Update.new(update_params).call
    render json: result
    
  end

  def update_params
    params.require(:role).permit(:name, :key).merge(id: params[:id])
  end
  
  

end   
