require 'pry'

module Api
	module V1
		class ParkingController < ApplicationController
      def index
        parking = Parking.order('created_at');
        render json: { data: parking }, status: :ok
      end

      def create
        # validate_plate(vehicle_params[:plate])

        vehicle = Vehicle.find_or_create_by(vehicle_params)


        binding.pry

        render json: { data: [] }, status: :ok
      end

      private

      def vehicle_params
        params.require(:parking).permit(:plate)
      end
		end
	end
end
