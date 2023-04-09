require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'User' do
	include JsonWebToken
	let(:supplier_role) { create(:role, name: 'Supplier',
		key: 'supplier') }

  let(:user_1) { create(:user, first_name: 'Sonal',
		role_id: supplier_role.id)}

	let(:raw_post) { params.to_json }
	
	let(:create_user) { create(:user,
		first_name: 'Demo',
		role_id: supplier_role.id)}
		
	post '/users' do
		before do
			header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
		end

		describe "User creation" do
			it "user creation should be successfully" do
				do_request(create_user)
				response_data = JSON.parse(response_body)
				expect(response_body["success"]).to eq(true)
				expect(response_body["message"]).to eq(I18n.t('user.success.create')
			)
			 
			end
		end
	end
end