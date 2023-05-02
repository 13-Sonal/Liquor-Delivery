class User < ApplicationRecord
  require "securerandom"
  belongs_to :role
  has_many :orders, dependent: :destroy
  validates_uniqueness_of :email_id
  validates_uniqueness_of :contact_number
  Role.pluck(:key).each do |rname|
   define_method "is_#{rname}?" do
     self.role.key == rname
      end
  end 
end

