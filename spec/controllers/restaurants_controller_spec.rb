require 'spec_helper'

describe RestaurantsController do
  let(:restaurant_params) do
    {
      name: 'Foo',
      description: 'Bar',
      address: '123 Fake St.',
      phone_number: '123-123-1234',
      owner_id: @owner.id,
    }
  end

  before :all do
    @owner = Owner.create!(name: "Brett Simpson", email: 'foo@bar.com', password: '12345678')
  end
  after :all do
    Restaurant.destroy_all
    Owner.destroy_all
  end

  context "required to be signed in" do
    before { sign_in @owner }

    describe "#create" do
      it "creates a new restaurant" do
        expect {
          post :create, restaurant: restaurant_params
        }.to change{Restaurant.count}.by(1)

        expect(response).to be_redirect
      end
    end

    describe "#edit" do
      let(:restaurant) { Restaurant.create!(restaurant_params) }

      it "loads the existing campaign" do
        get :edit, id: restaurant.id

        expect(controller.restaurant).to_not be_nil
      end
    end

    describe "#update" do
      let!(:restaurant) { Restaurant.create!(restaurant_params) }
      let(:new_restaurant_params) do
        {
          name: 'One',
          description: 'Two',
          address: '789 Imaginary St.',
          phone_number: '321-321-9876',
        }
      end

      it "saves the new data passed in" do
        put :update, id: restaurant.id, restaurant: new_restaurant_params

        expect(response).to be_redirect
        expect(controller.restaurant.name).to eq(new_restaurant_params[:name])
        expect(controller.restaurant.description).to eq(new_restaurant_params[:description])
        expect(controller.restaurant.address).to eq(new_restaurant_params[:address])
        expect(controller.restaurant.phone_number).to eq(new_restaurant_params[:phone_number])
      end

      it "re-renders the edit page on error" do
        put :update, id: restaurant.id, restaurant: new_restaurant_params.merge(name: '')

        expect(response).to_not be_redirect
      end
    end

    describe "#destroy" do
      let(:restaurant) { Restaurant.create!(restaurant_params) }

      it "loads the restaurant" do
        delete :destroy, id: restaurant.id

        expect(controller.restaurant).to_not be_nil
        expect { Restaurant.find_by!(id: restaurant.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    # describe "#delete_reservation" do
    #   let(:restaurant) { Restaurant.create!(restaurant_params) }
    #   let(:reservation) do
    #     Reservation.create(
    #       email: 'foo@bar.com',
    #       requested_at: 1.day.from_now.to_datetime,
    #       restaurant_id: restaurant.id
    #     )
    #   end
    #
    #   it "handles non-existent reservation gracefully" do
    #     get "restaurants/1/reservation/1/delete"
    #   end
    #
    #   it "deletes the reservation" do
    #     expect {
    #       get "restaurants/#{restaurant.id}/reservation/#{reservation.id}/delete"
    #     }.to change { Reservation.count }.by(1)
    #   end
    # end
  end

  context "not required to be signed in" do
    describe "#index" do
      it "succeeds" do
        get :index
        expect(response).to be_success
      end
    end

    describe "#show" do
      let(:restaurant) { Restaurant.create!(restaurant_params) }

      it "succeeds" do
        get :show, id: restaurant.id

        expect(response).to be_success
        expect(controller.restaurant).to_not be_nil
      end

      it "raises error for non-existent restaurant" do
        expect {
          get :show, id: 0
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "#create" do
      it "won't allow anonymous user to create a restaurant" do
        restaurant_params = {
          name: "1", description: "2",
          address: "3", phone_number: "4", owner_id: 1
        }

        before_count = Restaurant.count
        post :create, restaurant: restaurant_params

        expect(response).to be_redirect
        expect(Restaurant.count).to eq(before_count)
      end
    end
  end

end
