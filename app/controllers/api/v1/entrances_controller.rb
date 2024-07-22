# frozen_string_literal: true

module Api
  module V1
    class EntrancesController < ApiController
      before_action :set_entrance, only: %i[show update destroy]

      # GET /api/v1/entrances.json
      def index
        @entrances = Entrance.order(:created_at)
      end

      # GET /api/v1/entrances/1.json
      def show
      end

      def create
        Entrance.transaction do
          @entrance = Entrance.new(entrance_params)
          @entrance.save!
        end

        respond_to do |format|
          format.json do
            render :show,
                   status: :created,
                   location: api_v1_entrance_url(@entrance)
          end
        end
      end

      # PATCH/PUT /api/v1/entrances/1
      def update
        Entrance.transaction { @entrance.update!(entrance_params) }

        respond_to do |format|
          format.json do
            render :show, status: :ok, location: api_v1_entrance_url(@entrance)
          end
        end
      end

      # DELETE /api/v1/entrances/1
      def destroy
        Entrance.transaction { @entrance.destroy! }

        respond_to { |format| format.json { head :no_content } }
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_entrance
        @entrance = Entrance.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def entrance_params
        params
          .require(:entrance)
          .permit(:name)
          .each_value { |value| value.try(:strip!) }
      end
    end
  end
end
