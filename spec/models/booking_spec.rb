# frozen_string_literal: true

require "rails_helper"

RSpec.describe Booking do
  before do
    Entrance.create!(name: "A")
    Entrance.create!(name: "B")
    Entrance.create!(name: "C")
  end

  let!(:parking_lot) do
    parking_lot = ParkingLot.new(name: "PL1")
    parking_lot.parking_slots.build(slot_type: 0, distances: "1,2,3")
    parking_lot.save!
    parking_lot
  end
  let!(:parking_slot) { parking_lot.parking_slots.first }

  it "does not save without parking_slot" do
    booking = described_class.new(vehicle_type: VehicleType::TYPES[:small], plate_number: "ABC123")
    expect(booking.save).to be false
  end

  it "saves" do
    booking = described_class.new(parking_slot:, vehicle_type: VehicleType::TYPES[:small], plate_number: "ABC123")
    expect(booking.save).to be true
  end
end
