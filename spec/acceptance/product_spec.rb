require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Product' do
  include JsonWebToken
	
  let!(:user_1) do
    create(:user, first_name: 'Sonal',
                  role_id: Role.find_by(key: 'admin').id)
  end

  let!(:brand) { create(:brand, name: 'Smirnoff') }
	let!(:brand2) { create(:brand, name: 'Fine Wine',
		                             is_active: 'false') }

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
      id: 3,
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

	let(:inactive_brand) do
		{
			id: brand2.id, 
			product: build(:product,
				name: 'Beer',
				stock: '200',
				price: '1000').attributes.except('created_at', 'id', 'brand_id', 'updated_at')

		}
	end

  post '/brands/:id/product' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
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

			it "can not be created with inactive brand id" do
				do_request(inactive_brand)
				response_data = JSON.parse(response_body)
        expect(response_status).to eq(422)
        expect(response_data['success']).to eq(false)
				expect(response_data['message']).to eq(I18n.t('brand.error.not_found'))
			end
			
    end
  end

  put 'products/:id' do
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
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

      it "should fail when incorrect product id" do

      	do_request(update_invalid_id)
      	response_data = JSON.parse(response_body)

      	expect(response_status).to eq(422)
      	expect(response_data["success"]).to eq(false)
      	expect(response_data["message"]).to eq(I18n.t('product.error.not_found'))
      end
    end

    delete 'products/:id' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: user_1.id)
      end

      describe 'delete product' do
        it 'delete existing product successfully' do
          do_request(delete_product)
          response_data = JSON.parse(response_body)
          expect(response_status).to eq(200)
          expect(response_data['success']).to eq(true)
          expect(response_data['message']).to eq(I18n.t('product.success.destroy'))
        end

        it 'should fail with incorrect product id' do
          do_request(incorrect_prod_id)
          response_data = JSON.parse(response_body)
          expect(response_status).to eq(422)
          expect(response_data['message']).to eq(I18n.t('product.error.not_found'))
        end
      end

      get 'products/:id' do
        before do
          header 'Content-Type', 'application/json'
          header 'Authorization', jwt_encode(user_id: user_1.id)
        end

        describe 'View single product' do
          it 'User can view all the products' do
            do_request(show_prod)
            response_data = JSON.parse(response_body)
            expect(response_status).to eq(200)
            expect(response_data['message']).to eq(I18n.t('product.success.show'))
          end
        end
        it 'Should fail when product Id is invalid' do
          do_request({ id: 3 })
          response_data = JSON.parse(response_body)
          expect(response_status).to eq(422)
          expect(response_data['message']).to eq(I18n.t('product.error.not_found'))
        end
				it 'Should not list products with deleted/inactive brand' do
					do_request({ id: brand2.id})
					response_data = JSON.parse(response_body)
					expect(response_status).to eq(422)
					expect(response_data['message']).to eq(I18n.t('product.error.not_found'))
				end
      end
    end
  end
end
