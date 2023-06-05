class OrdersController < ApplicationController
  protect_from_forgery
  skip_load_resource only: [:create]

  def create
    result = Orders::Create.new(params, logged_in_user).call
    if result[:success]
      (render json: result)
    else
      (render json: result,
              status: :unprocessable_entity)
    end
  end
end
