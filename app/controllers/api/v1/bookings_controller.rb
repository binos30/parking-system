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
      def create # rubocop:disable Metrics/AbcSize
        Booking.transaction do
          parking_slot = FindAvailableParkingSlot.new(booking_params[:vehicle_type]).call
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

          parking_slot =
            FindClosestParkingSlot.new(
              @booking.vehicle_type,
              park_vehicle_params[:entrance_id]
            ).call
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
