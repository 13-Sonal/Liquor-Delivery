require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Role' do
  include JsonWebToken
  
  let(:supplier_role) { create(:role, name: 'Supplier',
    key: 'supplier') }

  let(:supplier_role_hash){
    {
     role: build(:role,
        name: 'Supplier',
        key: 'demo'
      ).attributes.except('id', 'created_at', 'updated_at') 
    } 
  }  

  let(:role_params) {
    {
    role: build(:role,
      name: 'Jeans',
      key: 'jeans'
    ).attributes.except('id', 'created_at', 'updated_at') }
  }
  let(:update_role) {
    {
    id: supplier_role.id,
    role: build(:role,
      name: 'Supplier2',
      key: 'supplier_2'
    ).attributes.except('id', 'created_at', 'updated_at') }
  }
  let(:missing_attributes) {
    {
    id: supplier_role.id,
    role: build(:role,
      
    ).attributes.except('id','name', 'key', 'created_at', 'updated_at') }
  }

 
  let(:user_1) { create(:user, first_name: 'Sonal',
  role_id: supplier_role.id)}
  let(:raw_post) { params.to_json }

  post '/roles' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
    end

    describe "#creating a role" do
      it "role can not be created when role name/key is already present" do
        do_request(supplier_role_hash)
        response_data = JSON.parse(response_body)
        expect(response_data["success"]).to eq(false)  
        expect(response_data["message"].include?("Name
          has already been taken")).to eq(true)
      end

      it 'role created successfuly' do
        role_count = Role.all.count
        do_request(role_params)
        response_data = JSON.parse(response_body)
        expect(response_data["success"]).to eq(true)  
        expect(response_data["message"]).to eq(I18n.t('role.success.create'))
        expect(Role.count).to eq(role_count + 1)
      end
    end
  end
  
  put '/roles/:id' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
    end

    describe "updating a role" do
      it 'role updated successfully' do
        do_request(update_role)
        role_count = Role.all.count
        response_data = JSON.parse(response_body)
        expect(response_data["success"]).to eq(true)
        expect(response_data["message"]).to eq(I18n.t('role.success.update'))
        expect(response_status).to eq(200)
      end

      it 'role should not be updated if parameters are missing' do
        do_request(missing_attributes)
        expect(response_status).to eq(400)
      end
    
      it 'role name should not be updated with existing name' do
        do_request(supplier_role_hash)
        response_data = JSON.parse(response_body)
        byebug
        expect(response_data["success"]).to eq(false)
        expect(response_status).to eq(200)
      end
    end

    delete '/roles/:id' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: user_1.id)
      end

      describe "role should get deleted" do
        it 'role should get deleted successfully' do
          role_count = Role.all.count
          byebug
          do_request(id: supplier_role.id)
          byebug
          expect(Role.count).to eq(role_count + 1)
          byebug
          response_body = JSON.parse(response_data)
          byebug
        end

      end
  end
end
end
