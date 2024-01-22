# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApiController
      before_action :set_booking, only: %i[show update destroy park_vehicle unpark_vehicle]

      # GET /api/v1/bookings or /api/v1/bookings.json
      def index
        @bookings = Booking.includes([:parking_slot]).order(:created_at)
      end

      # GET /api/v1/bookings/1 or /api/v1/bookings/1.json
      def show
      end

      # POST /api/v1/bookings or /api/v1/bookings.json
      def create
        Booking.transaction do
          parking_slot = available_parking_slot
          raise "Sorry, parking slots are full" if parking_slot.nil?

          @booking = Booking.new(booking_params.merge(parking_slot_id: parking_slot.id))
          @booking.save!
          parking_slot.reserved!
        end

        respond_to do |format|
          format.json { render :show, status: :created, location: api_v1_booking_url(@booking) }
        end
      end

      # PATCH/PUT /api/v1/bookings/1 or /api/v1/bookings/1.json
      def update
        Booking.transaction { @booking.update!(booking_params) }

        respond_to do |format|
          format.json { render :show, status: :ok, location: api_v1_booking_url(@booking) }
        end
      end

      # DELETE /api/v1/bookings/1 or /api/v1/bookings/1.json
      def destroy
        Booking.transaction { @booking.destroy! }

        respond_to { |format| format.json { head :no_content } }
      end

      def park_vehicle # rubocop:disable Metrics/AbcSize
        Booking.transaction do
          @booking.lock!
          raise "Vehicle already parked." if @booking.date_park.present?

          entrance_index =
            Entrance.order(:created_at).ids.index(park_vehicle_params[:entrance_id].to_i)
          raise "Entrance not found." if entrance_index.nil?

          parking_slot = parking_slot(@booking.vehicle_type, entrance_index)
          @booking.park_vehicle!(parking_slot, park_vehicle_params.except(:entrance_id))
        end

        respond_to do |format|
          format.json { render :show, status: :ok, location: api_v1_booking_url(@booking) }
        end
      end

      def unpark_vehicle
        Booking.transaction do
          @booking.lock!
          raise "Vehicle already unparked." if @booking.date_unpark.present?

          @booking.unpark_vehicle!(unpark_vehicle_params)
        end

        respond_to do |format|
          format.json { render :show, status: :ok, location: api_v1_booking_url(@booking) }
        end
      end

      private

      def available_parking_slot
        vehicle_type = booking_params[:vehicle_type]
        case vehicle_type
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

      # Find the parking slot closest to the entrance
      def parking_slot(vehicle_type, entrance_index) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
        case vehicle_type
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

      # Use callbacks to share common setup or constraints between actions.
      def set_booking
        @booking = Booking.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def booking_params
        params.require(:booking).permit(:vehicle_type, :plate_number)
      end

      def park_vehicle_params
        params.permit(:entrance_id, :date_park)
      end

      def unpark_vehicle_params
        params.permit(:date_unpark)
      end
    end
  end
end
