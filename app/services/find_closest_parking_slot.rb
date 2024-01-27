# frozen_string_literal: true

class FindClosestParkingSlot
  def initialize(vehicle_type, entrance_id)
    @vehicle_type = vehicle_type
    @entrance_id = entrance_id
  end

  def call # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    entrance_index = Entrance.order(:created_at).ids.index(@entrance_id.to_i)
    raise "Entrance not found." if entrance_index.nil?

    case @vehicle_type
    when "small"
      parking_slots =
        ParkingSlot
          .where(status: %i[vacant reserved])
          .map { |ps| { id: ps.id, distance: ps.distances_arr[entrance_index] } }
      parking_slot = parking_slots.min_by { |ps| ps[:distance] }
      ParkingSlot.find(parking_slot[:id])
    when "medium"
      parking_slots =
        ParkingSlot
          .where(status: %i[vacant reserved], slot_type: %i[medium large])
          .map { |ps| { id: ps.id, distance: ps.distances_arr[entrance_index] } }
      parking_slot = parking_slots.min_by { |ps| ps[:distance] }
      ParkingSlot.find(parking_slot[:id])
    when "large"
      parking_slots =
        ParkingSlot
          .where(status: %i[vacant reserved], slot_type: :large)
          .map { |ps| { id: ps.id, distance: ps.distances_arr[entrance_index] } }
      parking_slot = parking_slots.min_by { |ps| ps[:distance] }
      ParkingSlot.find(parking_slot[:id])
    else
      raise "Invalid vehicle type."
    end
  end
end
