# frozen_string_literal: true

module Api
  module V1
    class BookingsController < ApiController
      before_action :set_booking, only: %i[show update destroy]

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
          vehicle_type = booking_params[:vehicle_type]
          case vehicle_type
          when "small"
            parking_slot = ParkingSlot.where(status: :vacant).first
          when "medium"
            parking_slot = ParkingSlot.where(status: :vacant, slot_type: %i[medium large]).first
          when "large"
            parking_slot = ParkingSlot.where(status: :vacant, slot_type: :large).first
          else
            raise "Invalid vehicle type."
          end
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

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_booking
        @booking = Booking.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def booking_params
        params.require(:booking).permit(:entrance_id, :vehicle_type, :plate_number)
      end
    end
  end
end
