# frozen_string_literal: true

require "rails_helper"

RSpec.describe ParkingLot do
  it "does not save without name" do
    parking_lot = described_class.new
    expect(parking_lot.save).to be false
  end
end
