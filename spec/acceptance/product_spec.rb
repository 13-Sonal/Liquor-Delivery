require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'global_variable_helper'

resource 'Product' do
  include JsonWebToken

  let!(:brand) { create(:brand, name: 'Smirnoff') }

  let(:raw_post) { params.to_json }

  let(:create_product) do
    {
      id: brand.id,

      product: build(:product,
                     name: 'Beer',
                     stock: '200',
                     price: '1000').attributes.except('created_at', 'id', 'brand_id', 'updated_at')
    }
  end
  let(:product_2) do
    {
      id: Brand.find_by(name: 'brand 2').id,

      product: build(:product,
                     name: 'Beer',
                     stock: '200',
                     price: '1000').attributes.except('created_at', 'id', 'brand_id', 'updated_at')
    }
  end

  let!(:product1) { create(:product, name: 'db', brand_id: brand.id) }

  let(:missing_attr) do
    {
      id: brand.id,
      product: build(:product,
                     name: '').attributes.except('created_at', 'id', 'brand_id', 'updated_at')
    }
  end

  let(:incorrect_bId) do
    {
      id: 37_767,
      product: build(:product,
                     name: 'Beer',
                     stock: '200',
                     price: '1000').attributes.except('created_at', 'id', 'brand_id', 'updated_at')
    }
  end

  let(:delete_product) do
    {
      id: product1.id
    }
  end

  let(:incorrect_prod_id) do
    {
      id: 600
    }
  end

  let(:show_prod) do
    {
      id: product1.id
    }
  end
  let(:inactive_brand_prod) do
    {
      id: product_2.id
    }
  end

  let(:update_prod_name) do
    {
      id: product1.id,
      product: build(:product,
                     name: 'Wine',
                     stock: '20').attributes.except('created_at', 'id', 'brand_id', 'updated_at')
    }
  end

  let(:update_invalid_id) do
    {
      id: 500,
      product: build(:product,
                     name: 'Wine1', stock: '20')
    }
  end

  let(:dupliacate_name) do
    {
      id: product1.id,
      product: build(:product,
                     name: 'db')
    }
  end

  post '/brands/:id/product' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: $admin_user.id)
    end

    describe 'Product creation' do
      it 'Creating a product successfully' do
        do_request(create_product)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
        expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq(I18n.t('product.success.create'))
      end

      it "creation should be unsuccessful when
	  	invalid brand id is passed" do
        do_request(incorrect_bId)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(422)
        expect(response_data['success']).to eq(false)
      end

      it 'brand name missing' do
        do_request(missing_attr)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(422)
        expect(response_data['success']).to eq(false)
      end
    end
  end

  put 'products/:id' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: $admin_user.id)
    end

    describe 'product update' do
      it 'Product name can be updated successfully' do
        do_request(update_prod_name)

        response_data = JSON.parse(response_body)

        expect(response_status).to eq(200)
        expect(response_data['success']).to eq(true)
        expect(response_data['message']).to eq(I18n.t('product.success.update'))
        expect(Product.find_by(id: product1.id).name).to eq(update_prod_name[:product]['name'])
      end

      it 'should fail when incorrect product id' do
        do_request(update_invalid_id)
        response_data = JSON.parse(response_body)

        expect(response_status).to eq(422)
        expect(response_data['success']).to eq(false)
        expect(response_data['message']).to eq(I18n.t('product.error.not_found'))
      end
    end
  end

  get 'products/:id' do
    describe 'View single product' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: $admin_user.id)
      end
      it 'User can view all the products' do
        do_request(show_prod)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(200)
        expect(response_data['message']).to eq(I18n.t('product.success.show'))
      end
      it 'Should fail when product Id is invalid' do
        do_request({ id: 3 })
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(422)
        expect(response_data['message']).to eq(I18n.t('product.error.not_found'))
      end
    end
  end
end
