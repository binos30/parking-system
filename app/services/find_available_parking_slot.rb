# frozen_string_literal: true

class FindAvailableParkingSlot < ApplicationService
  def initialize(vehicle_type)
    @vehicle_type = vehicle_type
  end

  def call
    case @vehicle_type
    when "small"
      ParkingSlot.where(status: :vacant).first
    when "medium"
      ParkingSlot.where(status: :vacant, slot_type: %i[medium large]).first
    when "large"
      ParkingSlot.where(status: :vacant, slot_type: :large).first
    else
      raise "Invalid vehicle type."
    end
  end
end
