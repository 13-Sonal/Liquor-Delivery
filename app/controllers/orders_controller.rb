# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    result = Orders::Create.new(params, logged_in_user).call
    result[:success] ? (render json: result) : (render json: result, status: :unprocessable_entity)
  end
end
