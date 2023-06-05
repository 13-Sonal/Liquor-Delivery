require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'global_variable_helper'

resource 'Brand' do
  include JsonWebToken

  let(:show_brand) do
    {
      id: brand_1.id
    }
  end
  let(:missing_params) do
    {
      brand: build(:brand,
                   name: '').attributes.except('id', 'created_at', 'updated_at')
    }
  end
  let(:same_brand_name) do
    {
      brand: build(:brand,
                   name: 'Smirnoff').attributes.except('id', 'created_at', 'updated_at')
    }
  end
  let(:create_brand) do
    {
      brand: build(:brand,
                   name: 'Kingfisher').attributes.except('id', 'created_at', 'updated_at')
    }
  end
  let(:update_brand) do
    {
      id: brand_1.id,
      brand: build(:brand,
                   name: 'kf').attributes.except('id', 'created_at', 'updated_at')
    }
  end

  let!(:brand_1) { create(:brand, name: 'Smirnoff') }

  let(:raw_post) { params.to_json }

  post '/brands' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: $admin_user.id)
    end

    describe '#creating a brand' do
      it 'brand should be created successfully' do
        do_request(create_brand)
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq('Brand created successfully!!')
      end

      it 'brand can not be created when brand name is already present' do
        do_request(same_brand_name)
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(false)
        expect(response_data['message'].include?("Name
				has already been taken")).to eq(false)
      end
    end
  end
  post '/brands' do
    describe 'Brand creation as customer' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: $customer_user.id)
      end

      it 'Customer user should not be able to create brand' do
        do_request(create_brand)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(401)
        expect(response_data['message']).to eq('You are not authorized to access this page.')
      end
    end
  end

  put '/brands/:id' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: $admin_user.id)
    end

    describe 'updating brand successfully' do
      it 'Brands can be updated successfully' do
        do_request(update_brand)
        response_data = JSON.parse(response_body)
        expect(Brand.find_by(id: brand_1.id).name).to eq(update_brand[:brand]['name'])
        expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq(I18n.t('brand.success.update'))
        expect(response_status).to eq(200)
      end

      it 'Brand should not be updated when invalid brand_id is passed' do
        do_request(missing_params)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(422)
        expect(response_data['success']).to eq(false)
      end
    end
  end
  put '/brands/:id' do
    describe 'Brand update as customer' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: $customer_user.id)
      end

      it 'Customer user should not be able to create brand' do
        do_request(update_brand)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(401)
        expect(response_data['message']).to eq('You are not authorized to access this page.')
      end
    end
  end

  get '/brands/:id' do
    describe 'Show Brand' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: $admin_user.id)
      end
      it 'Display single brand' do
        do_request(show_brand)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
        expect(response_data['success']).to eq(true)
        expect(response_data['data']['name']).to eq(brand_1.name)
      end

      it 'Display single brand' do
        do_request({ id: 6726 })
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(422)
        expect(response_data['success']).to eq(false)
        expect(response_data['message']).to eq(I18n.t('brand.error.not_found'))
      end
    end
  end

  get '/brands' do
    describe 'List all the brands' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: $admin_user.id)
      end

      it 'Admin/Supplier should be able to view all brands' do
        do_request({})
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
        expect(response_data['success']).to eq(true)
        expect(response_data['count']).to eq(Brand.all.count)
      end
    end

    describe 'List active brands' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: $customer_user.id)
      end

      it 'Customer should be able to view only active brands' do
        do_request({})
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
        expect(response_data['success']).to eq(true)
        expect(response_data['count']).to eq(Brand.active.count)
      end
    end
  end
# ToDo- handle delete brand 
  # put '/brands/:id' do
  #   describe 'Delete a brand' do
  #     before do
  #       header 'Content-Type', 'application/json'
  #       header 'Authorization', jwt_encode(user_id: $admin_user.id)
  #     end
  #     it 'Brand can be deleted successfully' do
  #       byebug
  #       do_request(show_brand)
  #       byebug
  #       response_data = JSON.parse(response_body)
  #       byebug
  #       expect(response_status).to eq(200)
  #       expect(response_data['success']).to eq(true)
  #       expect(response_data['message']).to eq(I18n.t('brand.success.destroy'))
  #     end

  #     it 'Brand can not be deleted if brand is not present for mentioned Id' do
  #       do_request(id: 787)
  #       response_data = JSON.parse(response_body)
  #       expect(response_status).to eq(422)
  #       expect(response_data['message']).to eq(I18n.t('brand.error.not_found'))
  #     end
  #   end
  #   describe 'Delete a brand as supplier/Customer' do
  #     before do
  #       header 'Content-Type', 'application/json'
  #       header 'Authorization', jwt_encode(user_id: $supplier_user.id)
  #     end
  #     it 'Supplier should not be able to delete any brand' do
  #       do_request(show_brand)
  #       response_data = JSON.parse(response_body)
  #       expect(response_status).to eq(401)
  #       expect(response_data['message']).to eq('You are not authorized to access this page.')
  #     end
  #   end
  # end
end
