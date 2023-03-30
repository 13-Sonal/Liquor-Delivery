require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Brand' do
    include JsonWebToken

    let(:brand) { create(:brand, name: "Glass",
      key: 'glass') }
		
		let(:new_brand)
		{ 
			brand: build(:brand,
			name: 'Glass',
			key: 'glass') 
		}	

		let(:user) { create(:user, name:'Sonal',
			role_id:'1')
		}
			
		let(:raw_post) { params.to_json }	



	post '/brands' do
		before do
					header 'Content-Type', 'application/json'
					header 'Authorization', jwt_encode(user_id: user.id)
		end
		
		describe "#creating a role" do
			it "brand can not be created when role name/key is already present" do
				byebug
				do_request(new_brand)
				byebug
				response_data = JSON.parse(response_body)
				expect(response_data["success"]).to eq(false)  
				expect(response_data["message"].include?("Name
				has already been taken")).to eq(true)
					end
		
				end

			end


end