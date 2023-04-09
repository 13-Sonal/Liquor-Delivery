require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Brand' do
  include JsonWebToken

	let(:raw_post) { params.to_json }
	
	let(:supplier_role) { create(:role, name: 'Supplier',
		key: 'supplier') }

	let(:user_1) { create(:user, first_name: 'Sonal',
		role_id: supplier_role.id) }
	
	let(:brand) { create(:brand, name: 'Smirnoff',
		key:'smirnoff') }
	
	let(:raw_post) { params.to_json }

	let(:create_product) {
		{
			product: build(:product,
			brand_id: brand.id,
			name: 'Beer',
			stock: '200',
			price: '1000'
			).attributes.except('created_at', 'updated_at')	}
	}

	describe "Product creation" do
		it "Creating a product successfully" do
			byebug
			#response_data = JSON.parse(response_body)
			do_request(create_product)
			byebug
			expect(response_status).to eq(400)
		end
		
		it "creation should be unsuccessful when incorrect brand id is providedss"
	end
end	




	
