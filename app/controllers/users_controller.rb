class UsersController < ApplicationController
  protect_from_forgery

  def create
    result = Users::Create.new(create_params).call
    render json: result
  end  

  def create_params
    params.require(:user).permit(:first_name, :last_name, :contact_number, :email_id, :role_id, :password)
 
  end
  
  def update
    result = Users::Update.new(updated_params).call
    render json: result
  end

  def updated_params
    create_params.merge(id: params[:id])
  end

end
