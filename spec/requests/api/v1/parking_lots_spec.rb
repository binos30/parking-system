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

RSpec.describe "/api/v1/parking_lots" do
  # before do
  #   Entrance.create!(name: "A")
  #   Entrance.create!(name: "B")
  #   Entrance.create!(name: "C")
  # end

  # This should return the minimal set of attributes required to create a valid
  # ParkingLot. As you add validations to ParkingLot, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { name: "PL" } }

  let(:invalid_attributes) { { name: "" } }

  let(:valid_slots_attributes) { [{ slot_type: "small", distances: "1,2,3" }] }

  describe "GET /index" do
    it "renders a successful response" do
      parking_lot = ParkingLot.new(valid_attributes)
      parking_lot.parking_slots.build(valid_slots_attributes)
      parking_lot.save!
      get api_v1_parking_lots_url
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      parking_lot = ParkingLot.new(valid_attributes)
      parking_lot.parking_slots.build(valid_slots_attributes)
      parking_lot.save!
      get api_v1_parking_lot_url(parking_lot)
      expect(response).to have_http_status(:success)
      json = response.parsed_body
      expect(json["name"]).to eq("PL")
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new ParkingLot" do
        expect do
          post api_v1_parking_lots_url,
               params: {
                 parking_lot: {
                   **valid_attributes,
                   parking_slots_attributes: valid_slots_attributes
                 }
               }
        end.to change(ParkingLot, :count).by(1)
      end

      it "returns a created status" do
        post api_v1_parking_lots_url,
             params: {
               parking_lot: {
                 **valid_attributes,
                 parking_slots_attributes: valid_slots_attributes
               }
             }
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new ParkingLot" do
        expect do post api_v1_parking_lots_url, params: { parking_lot: invalid_attributes } end.not_to change(
          ParkingLot,
          :count
        )
      end

      it "renders a response with 422 status" do
        post api_v1_parking_lots_url, params: { parking_lot: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "PL1" } }

      it "updates the requested api_v1_parking_lot" do
        parking_lot = ParkingLot.new(valid_attributes)
        parking_lot.parking_slots.build(valid_slots_attributes)
        parking_lot.save!
        patch api_v1_parking_lot_url(parking_lot), params: { parking_lot: new_attributes }
        parking_lot.reload
        expect(parking_lot.name).to eq("PL1")
      end
    end

    context "with invalid parameters" do
      it "renders a response with 422 status" do
        parking_lot = ParkingLot.new(valid_attributes)
        parking_lot.parking_slots.build(valid_slots_attributes)
        parking_lot.save!
        patch api_v1_parking_lot_url(parking_lot), params: { parking_lot: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested api_v1_parking_lot" do
      parking_lot = ParkingLot.new(valid_attributes)
      parking_lot.parking_slots.build(valid_slots_attributes)
      parking_lot.save!
      expect { delete api_v1_parking_lot_url(parking_lot) }.to change(ParkingLot, :count).by(-1)
    end
  end
end
