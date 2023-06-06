class Role < ApplicationRecord
  has_one :user, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
