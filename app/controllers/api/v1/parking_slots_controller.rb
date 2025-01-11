# frozen_string_literal: true

module Api
  module V1
    class ParkingSlotsController < ApiController
      # GET /api/v1/parking_slots.json
      def index
        @parking_slots = ParkingSlot.order(:id)
      end
    end
  end
end
