require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'global_variable_helper'

resource 'Order' do
  include JsonWebToken

  let(:raw_post) { params.to_json }

  let!(:brand_1) { create(:brand, name: 'Smirnoff') }

  let!(:product_1) do
    create(:product, name: 'prod1', stock: '100',
                     price: '500', brand_id: brand_1.id)
  end

  let!(:product_2) do
    create(:product, name: 'prod1', stock: '100',
                     price: '500', brand_id: brand_1.id)
  end

  let(:place_order) do
    {
      order:
      {
        products:
        [
          {
            product_id: product_1.id,
            items: '10'
          },
          {
            product_id: product_2.id,
            items: '5'
          }
        ]
      }
    }
  end

  let(:incorrect_prod_id) do
    {
      order:
      {
        products:
        [
          {
            product_id: 7866,
            items: '10'
          },
          {
            product_id: product_2.id,
            items: '5'
          }
        ]
      }
    }
  end

  post '/orders' do
    describe 'Order Creation' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: $admin_user.id)
      end
      it 'Order should be created successfully' do
        do_request(place_order)
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(true)
        expect(response_data['message'].include?('Order successfully placed'))
      end

      it 'Order should not be created in case invlaid product id is passed' do
        do_request(incorrect_prod_id)
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(false)
        expect(response_data['message'].include?('Product must exist'))
      end

      it 'Order should not be created in case order quantity exceeds available stock' do
        do_request(incorrect_prod_id)
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(false)
        expect(response_data['message'].include?('Unable to place the order'))
      end

      it 'Wth order failure, the stock qunatity should not be reduced' do
        do_request(incorrect_prod_id)
        response_data = JSON.parse(response_body)
        expect(response_data['success']).to eq(false)
        expect(product_1.stock).to eq(Product.find_by(id: product_1.id).stock)
        expect(response_data['message'].include?('Unable to place the order'))
      end
    end

    describe 'Order creation as Supplier' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: $supplier_user.id)
      end

      it 'Order creation should not be allowed for supplier' do
        do_request(place_order)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(401)
        expect(response_data['message']).to eq('You are not authorized to access this page.')
      end
    end

    describe 'Order creation as Customer' do
      before do
        header 'Content-Type', 'application/json'
        header 'Authorization', jwt_encode(user_id: $customer_user.id)
      end

      it 'Order creation should not be allowed for customer' do
        do_request(place_order)
        response_data = JSON.parse(response_body)
        expect(response_status).to eq(401)
        expect(response_data['message']).to eq('You are not authorized to access this page.')
      end
    end
  end
end
