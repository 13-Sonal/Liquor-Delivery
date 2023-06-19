# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin_role = Role.find_or_create_by(name: "Admin", key: "admin")
supplier_role = Role.find_or_create_by(name: "Supplier", key: "supplier")
customer_role = Role.find_or_create_by(name: "Customer", key: "customer")
Brand.find_or_create_by(name: "B1")
Brand.find_or_create_by(name: "B2", is_active: false)
Brand.find_or_create_by(name: "B3", is_active: false)
admin_user = User.find_or_create_by(first_name: 'admin',
  email_id: 'admin@gmail.com',
  contact_number: "9267626",
  role_id: admin_role.id,
  password: 'password')

supplier_user = User.find_or_create_by(first_name: 'supplier',
  email_id: 'supplier@gmail.com',
  contact_number: "7826727",
  role_id: supplier_role.id,
  password: 'password')

customer_user = User.find_or_create_by(first_name: 'customer',
  email_id: 'customer@gmail.com', 
  contact_number: "7867267",
  role_id: customer_role.id,
  password: 'password')    