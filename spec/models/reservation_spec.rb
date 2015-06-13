require 'spec_helper'

describe Reservation do
  after :all do
    # This also destroys all reservations
    # See: https://github.com/matthuhiggins/foreigner#change-table-methods
    Restaurant.destroy_all
    expect(Reservation.count).to eq(0)
  end

  context "required fields" do
    let(:restaurant) do
      Restaurant.create(
        name: "A Restaurant",
        description: "Good Food",
        address: "123 fake st.",
        phone_number: "123-123-1234"
      )
    end
    let(:valid_fields) do
      {
        email: "foo@bar.com",
        requested_at: Time.now.to_datetime,
        restaurant_id: restaurant.id,
        message: "Time to eat!"
      }
    end

    [ :email, :requested_at, :restaurant_id ].each do |field|
      it "requires #{field} field" do
        expect {
          Reservation.create!(valid_fields.merge(field => nil))
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    it "is successful with all required fields" do
      expect {
        Reservation.create!(valid_fields)
      }.to change { Reservation.count }.by(1)
    end
  end
end
