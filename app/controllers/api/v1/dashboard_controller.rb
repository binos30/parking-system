# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApiController
      def index # rubocop:disable Metrics/AbcSize
        @small_vacant_slots_count = ParkingSlot.small.vacant.count
        @medium_vacant_slots_count = ParkingSlot.medium.vacant.count
        @large_vacant_slots_count = ParkingSlot.large.vacant.count

        @small_reserved_slots_count = ParkingSlot.small.reserved.count
        @medium_reserved_slots_count = ParkingSlot.medium.reserved.count
        @large_reserved_slots_count = ParkingSlot.large.reserved.count

        @small_occupied_slots_count = ParkingSlot.small.occupied.count
        @medium_occupied_slots_count = ParkingSlot.medium.occupied.count
        @large_occupied_slots_count = ParkingSlot.large.occupied.count
      end
    end
  end
end
