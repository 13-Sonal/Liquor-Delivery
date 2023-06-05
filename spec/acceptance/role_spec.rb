require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'global_variable_helper'

resource 'Role' do
  include JsonWebToken

  # let!(:customer) { create(:role, name: 'Customer', key: 'customer') }
  let(:supp_role_hash) do
    {
      role: build(:role,
                  name: 'Supplier',
                  key: 'demo').attributes.except('id', 'created_at', 'updated_at')
    }
  end

  let(:role_params) do
    {
      role: build(:role,
                  name: 'Jeans',
                  key: 'jeans').attributes.except('id', 'created_at', 'updated_at')
    }
  end
  let(:update_role) do
    {
      id: Role.find_by(key: 'supplier').id,
      role: build(:role,
                  name: 'Supplier2',
                  key: 'supplier_2').attributes.except('id', 'created_at', 'updated_at')
    }
  end
  let(:missing_attributes) do
    {
      id: Role.find_by(key: 'supplier').id,
      role: build(:role).attributes.except('id', 'name', 'key', 'created_at', 'updated_at')
    }
  end

  let(:raw_post) { params.to_json }

  post '/roles' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: $admin_user.id)
    end

    describe '#creating a role' do
      it 'role can not be created when role name/key is already present' do
        do_request(supp_role_hash)
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(false)
        expect(response_data['message'].include?("Name
          has already been taken"))
      end

      it 'role created successfuly' do
        role_count = Role.all.count
        do_request(role_params)
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq(I18n.t('role.success.create'))
        expect(Role.count).to eq(role_count + 1)
      end
    end
  end

  put '/roles/:id' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: $admin_user.id)
    end

    describe 'updating a role' do
      it 'role updated successfully' do
        do_request(update_role)
        role_count = Role.all.count
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq(I18n.t('role.success.update'))
        expect(response_status).to eq(200)
      end

      it 'role should not be updated if parameters are missing' do
        do_request(missing_attributes)
        expect(response_status).to eq(400)
      end

      it 'role name should not be updated with existing name' do
        do_request(supp_role_hash)
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(false)
        expect(response_status).to eq(200)
      end
    end

    # delete '/roles/:id' do
    #   before do
    #     header 'Content-Type', 'application/json'
    #     header 'Authorization', jwt_encode(user_id: admin.id)
    #   end

    #   describe 'role should get deleted' do
    #     it 'role should get deleted successfully' do
    #       role_count = Role.all.count
    #       do_request({id: customer.id})
    #       expect(Role.count).to eq(role_count - 1)
    #       response_body = JSON.parse(response_data)
    #     end
    #   end
    # end
  end
end
