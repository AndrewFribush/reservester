require 'spec_helper'

class RestaurantsHelperClass
  include RestaurantsHelper
end

describe RestaurantsHelper do
  let(:restaurant) do
    Restaurant.create(
      name: "1", description: "2",
      address: "3", phone_number: "4", owner: @owner
    )
  end
  let(:helper) { RestaurantsHelperClass.new }

  before :all do
    @owner = Owner.create!(name: "John Harrison", email: "foo@bar.com", password: "12345678")
  end
  after :all do
    Owner.destroy_all
    Restaurant.destroy_all
  end

  describe "#current_owner_owns_restaurant" do
    context "not signed in" do
      before do
        RestaurantsHelperClass.any_instance.stub(:current_owner) { nil }
      end

      it "returns false if not signed in" do
        result = helper.current_owner_owns_restaurant(restaurant)
        expect(result).to be_false
      end
    end

    context "signed in as owner" do
      let(:other_owner) { Owner.create!(name: "Marky Johnson", email: "chaz@baz.com", password: "12345678")}

      it "returns false if signed in, but you don't own the restaurant" do
        RestaurantsHelperClass.any_instance.stub(:current_owner) { other_owner }
        result = helper.current_owner_owns_restaurant(restaurant)

        expect(result).to be_false
      end

      it "returns true if signed in and you own the restaurant" do
        RestaurantsHelperClass.any_instance.stub(:current_owner) { @owner }
        result = helper.current_owner_owns_restaurant(restaurant)

        expect(result).to be_true
      end
    end
  end
end
