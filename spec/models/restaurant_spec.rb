require 'spec_helper'

describe Restaurant do
  let(:valid_attributes) do
    {
      name: "My Awesome Restaurant",
      description: "Southwest Thai BBQ Fusion",
      address: "123 fake street Chicago IL",
      phone_number: "123-123-1234"
    }
  end

  it "creates a new restaurant with valid fields" do
    restaurant = Restaurant.create!(valid_attributes)

    expect(restaurant).to_not be_nil
    expect(restaurant.name).to eq(valid_attributes[:name])
    expect(restaurant.description).to eq(valid_attributes[:description])
    expect(restaurant.address).to eq(valid_attributes[:address])
    expect(restaurant.phone_number).to eq(valid_attributes[:phone_number])
  end

  context "required fields" do
    required_fields = [:name, :description, :address, :phone_number]

    required_fields.each do |field|
      it "requires #{field} field" do
        expect { Restaurant.create!(valid_attributes.merge(field => nil)) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
