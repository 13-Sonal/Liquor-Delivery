# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    case
    when user.is_admin?
      admin
    when user.is_supplier?
      supplier
    when user.is_customer?
      customer
    end
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
    can [:create], Order
  end
end
