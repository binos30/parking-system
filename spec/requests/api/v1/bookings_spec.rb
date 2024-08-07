# frozen_string_literal: true

require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/api/v1/bookings" do
  before do
    Entrance.create!(name: "A")
    Entrance.create!(name: "B")
    Entrance.create!(name: "C")
  end

  # This should return the minimal set of attributes required to create a valid
  # Booking. As you add validations to Booking, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { vehicle_type: VehicleType::TYPES[:small], plate_number: "ABC123" } }
  # let(:valid_attributes) do
  #   parking_lot = ParkingLot.new(name: "PL")
  #   parking_slot =
  #     parking_lot.parking_slots.build({ slot_type: 0, distances: "1,2,3" })
  #   parking_lot.save!
  #   {
  #     parking_slot_id: parking_slot.id,
  #     vehicle_type: VehicleType::TYPES[:small],
  #     plate_number: "ABC123"
  #   }
  # end

  let(:invalid_attributes) { { parking_slot_id: nil } }

=begin # rubocop:disable Style/BlockComments
  describe "GET /index" do
    it "renders a successful response" do
      parking_lot = ParkingLot.new(name: "PL1")
      parking_slot =
        parking_lot.parking_slots.new({ slot_type: 0, distances: "1,2,3" })
      parking_lot.save!
      Booking.create!(valid_attributes.merge!(parking_slot:))
      get api_v1_bookings_url
      expect(response).to have_http_status(:success)
    end
  end
=end
  describe "GET /show" do
    it "renders a successful response" do
      # booking = Booking.create! valid_attributes
      parking_lot = ParkingLot.new(name: "PL1")
      parking_slot = parking_lot.parking_slots.new({ slot_type: 0, distances: "1,2,3" })
      parking_lot.save!
      booking = Booking.create!(valid_attributes.merge!(parking_slot:))
      get api_v1_booking_url(booking)
      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json["vehicle_type"]).to eq("small")
      expect(json["plate_number"]).to eq("ABC123")
    end
  end

=begin # rubocop:disable Style/BlockComments
  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Booking" do
        expect do
          post api_v1_bookings_url, params: { booking: valid_attributes }
        end.to change(Booking, :count).by(1)
      end

      it "returns a created status" do
        post api_v1_bookings_url, params: { booking: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Booking" do
        expect do
          post api_v1_bookings_url, params: { booking: invalid_attributes }
        end.not_to change(Booking, :count)
      end

      it "renders a response with 422 status" do
        post api_v1_bookings_url, params: { booking: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { plate_number: "ABC12" } }

      it "updates the requested api_v1_booking" do
        booking = Booking.create! valid_attributes
        patch api_v1_booking_url(booking), params: { booking: new_attributes }
        booking.reload
        expect(booking.plate_number).to eq("ABC12")
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status" do
        booking = Booking.create! valid_attributes
        patch api_v1_booking_url(booking),
              params: {
                booking: invalid_attributes
              }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested api_v1_booking" do
      booking = Booking.create! valid_attributes
      expect { delete api_v1_booking_url(booking) }.to change(
        Booking,
        :count
      ).by(-1)
    end
  end
=end
end
