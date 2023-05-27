require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource 'Order' do
  include JsonWebToken

  let(:raw_post) { params.to_json }

  let(:user_1) do
    create(:user, first_name: 'Sonal',
                  role_id: Role.find_by(key: 'admin').id)
  end
  let!(:brand_1) { create(:brand, name: 'Smirnoff') }

  let!(:product_1) { create(:product, name: 'prod1', stock: '100',
    price: '500', brand_id: brand_1.id) } 

  let!(:product_2) { create(:product, name: 'prod1', stock: '100',
    price: '500', brand_id: brand_1.id) }

  let(:place_order) do
    {
      order:
      {
          products:
          [
              {
                product_id: product_1.id,
                items: "10" 
              },
              {
                product_id: product_2.id,
                items: "5" 
              }
          ]
      }
    }
  end 

  
  post '/orders' do
    
    before do
      header 'Content-Type', 'application/json'
      header 'Authorization', jwt_encode(user_id: user_1.id)
    end


    describe "Order Creation" do
      it "Order should br created successfully" do
        do_request(place_order)
        response_data = JSON.parse(response_body)
        byebug
        expect(response_data['success']).to eq(true)
        expect(response_data['message'].include?("Order successfully placed"))
      end
    end
    
  end

end