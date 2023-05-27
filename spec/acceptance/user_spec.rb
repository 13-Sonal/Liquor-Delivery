require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'User' do
  include JsonWebToken

	let(:raw_post) { params.to_json }

	let!(:user_1) do
    create(:user, first_name: 'Sonal',
                  role_id: Role.find_by(key: 'admin').id)
		end								
	let!(:user_2) do
		{
		user: build(:user,
			first_name: 'Joe', role_id: Role.find_by(
				key: 'supplier').id).attributes.except(
					'id', 'created_at', 'updated_at')
		}	
	let!(:user_3) do
			{
			user: build(:user,
				first_name: 'Carie', role_id: Role.find_by(
					key: 'supplier').id).attributes.except(
						'id', 'created_at', 'updated_at')
	   	}					
  end
	let!(:invalid_role) do
		{
		user: build(:user,
			first_name: 'Joe', role_id: 5).attributes.except(
					'id', 'created_at', 'updated_at')
		}				
  end

	let!(:updated_user) do
		{ 
			id: user_1.id,
			user: build(:user,
			first_name: 'Riho', email_id: 'riho@yahoo.com').attributes.except(
				'id', 'created_at','role_id', 'updated_at')
		}
	end
	let!(:updated_user) do
		{ 
			id: user_1.id,
			user: build(:user,
			first_name: 'Riho', email_id: 'riho@yahoo.com').attributes.except(
				'id', 'created_at','role_id', 'updated_at')
		}
	end

	post '/users' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
    end

    describe '#creating a user' do
      it 'user should be created successfully' do          
        do_request(user_2)
        response_data = JSON.parse(response_body)
				expect(response_status).to eq(200)
        expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq(I18n.t('user.success.create'))
      end

			it "should not be created when role id does not exists" do
				do_request(invalid_role)
				response_data = JSON.parse(response_body)
				expect(response_status).to eq(422)
        expect(response_data['success']).to eq(false)
        expect(response_data['message'].include?("Role must exist"))
			end
		end
  end

	put '/users/:id' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
    end
    
    describe 'updating user successfully' do
      it 'User can be updated successfully' do
        do_request(updated_user)
        response_data = JSON.parse(response_body)
        expect(User.find_by(id: user_1.id).first_name).to eq(updated_user[:user]['first_name'])
				expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq(I18n.t('user.success.update'))
        expect(response_status).to eq(200)
      end
			it "can not be created with invalid user id" do
				do_request(updated_user)
        response_data = JSON.parse(response_body)
        expect(User.find_by(id: user_1.id).first_name).to eq(updated_user[:user]['first_name'])
				expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq(I18n.t('user.success.update'))
        expect(response_status).to eq(200)
			end
			
		end
	end
	
	get '/users/:id' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
    end

    describe 'View all brands' do
      it 'Display single product' do
        do_request({id: user_1.id})
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
        expect(response_data['success']).to eq(true)
				expect(response_data['data']['first_name'].include?(user_1.first_name))
      end
			it "should not dispaly any product with invalid brand id" do
				do_request({id: 765})
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(422)
        expect(response_data['success']).to eq(false)
			end
			
    end
  end

  delete '/brands/:id' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
    end

    describe 'Delete a brand' do
      it 'Brand can be deleted successfully' do
        do_request({id: user_3.id})
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
        expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq(I18n.t('brand.success.destroy'))
      end

      it 'Brand can not be deleted if brand is not present for mentioned Id' do
        do_request(id: 787)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(422)
        expect(response_data['message']).to eq(I18n.t('brand.error.not_found'))
      end
    end
  end	
end
end