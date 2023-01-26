class Role < ApplicationRecord
  has_one :user, dependent: :destroy
end
