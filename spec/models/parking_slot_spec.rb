# frozen_string_literal: true

require "rails_helper"

RSpec.describe ParkingSlot do
  it "does not save without slot type" do
    parking_slot = described_class.new(distances: "")
    expect(parking_slot.save).to be false
  end
end
