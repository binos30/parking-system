# frozen_string_literal: true

module Api
  module V1
    class ParkingLotsController < ApiController
      before_action :set_parking_lot, only: %i[show update destroy]

      # GET /api/v1/parking_lots.json
      def index
        @parking_lots = ParkingLot.includes([:parking_slots]).order(:created_at)
      end

      # GET /api/v1/parking_lots/1.json
      def show
      end

      def create
        ParkingLot.transaction do
          @parking_lot = ParkingLot.new(parking_lot_params)
          @parking_lot.save!
        end

        respond_to do |format|
          format.json do
            render :show, status: :created, location: api_v1_parking_lot_url(@parking_lot)
          end
        end
      end

      # PATCH/PUT /api/v1/parking_lots/1 or /api/v1/parking_lots/1.json
      def update
        ParkingLot.transaction { @parking_lot.update!(parking_lot_params) }

        respond_to do |format|
          format.json { render :show, status: :ok, location: api_v1_parking_lot_url(@parking_lot) }
        end
      end

      # DELETE /api/v1/parking_lots/1
      def destroy
        ParkingLot.transaction { @parking_lot.destroy! }

        respond_to { |format| format.json { head :no_content } }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_parking_lot
        @parking_lot = ParkingLot.find(params[:id])
      end

      def parking_slots_params
        %i[id slot_type distances _destroy]
      end

      # Only allow a list of trusted parameters through.
      def parking_lot_params
        params
          .require(:parking_lot)
          .permit(:name, parking_slots_attributes: parking_slots_params)
          .each_value { |value| value.try(:strip!) }
      end
    end
  end
end
