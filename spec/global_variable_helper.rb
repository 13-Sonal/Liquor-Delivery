require 'rails_helper'
require 'rspec_api_documentation/dsl'

$admin_user = User.find_by(first_name: "admin")
$supplier_user = User.find_by(first_name: "supplier")
$customer_user = User.find_by(first_name: "customer")
