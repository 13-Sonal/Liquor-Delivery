class Role < ApplicationRecord
  has_one :user, dependent: :destroy
  validates_uniqueness_of :name, :key, presence: true
  
end
