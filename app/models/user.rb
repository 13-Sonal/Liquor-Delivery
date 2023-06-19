class User < ApplicationRecord
  require "securerandom"
  belongs_to :role
  has_many :orders, dependent: :destroy
  validates :email_id, presence: true, uniqueness: true
  validates :contact_number, presence: true, uniqueness: true
  Role.pluck(:key).each do |rname|
   define_method "is_#{rname}?" do
     self.role.key == rname
    end
  end 
end

