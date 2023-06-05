# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    admin if user.is_admin?
    supplier if user.is_supplier?
    customer if user.is_customer?
  end


  def admin
    can :manage, :all
  end

  def supplier
    can [:index, :show], Role
    can [:create, :update, :index, :show], Brand
    can [:create, :update, :index, :show], Product
  end

  def customer
    can [:index, :show], Brand
    can [:index, :show], Role
    can [:index, :show], Product
    can [:order], Order
  end
end
