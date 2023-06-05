class ProductsController < ApplicationController
  protect_from_forgery
  def create
    result = Products::Create.new(create_params).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end

  def update
    result = Products::Update.new(update_params).call
    if result[:success]
      (render json: result)
    else
      (render json:
            result, status: :unprocessable_entity)
    end
  end

  def destroy
    result = Products::Destroy.new(delete_params).call
    if result[:success]
      (render json: result)
    else
      (render json: result,
              status: :unprocessable_entity)
    end
  end

  def index
    result = Products::Index.new(params, logged_in_user).call
    if result[:success]
      (render json: result)
    else
      (render json: result,
              status: :unprocessable_entity)
    end
  end

  def show
    result = Products::Show.new(show_params, logged_in_user).call
    if result[:success]
      (render json: result)
    else
      (render json: result,
              status: :unprocessable_entity)
    end
  end

  private

  def delete_params
    params.merge(id: params[:id])
  end

  def create_params
    params.require(:product).permit(:name, :price,
                                    :stock).merge(brand_id: params[:id])
  end

  def update_params
    params.require(:product).permit(:quantity, :name,
                                    :price, :stock).merge(product_id: params[:id])
  end

  def show_params
    params.merge(id: params[:id])
  end
end
