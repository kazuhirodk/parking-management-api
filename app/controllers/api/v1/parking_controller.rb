# frozen_string_literal: true

require 'pry'

module Api
  module V1
    class ParkingController < ApplicationController
      def index
        parking = Parking.order('created_at')
        render json: { data: parking }, status: :ok
      end

      def create
        # validate_plate(vehicle_params[:plate])

        vehicle = Vehicle.find_or_create_by(vehicle_params)

        parking_ticket = Parking.create(
          entrance_date: Time.current,
          vehicle_id: vehicle.id
        )

        render json: { booking_reference_number: parking_ticket.id }, status: :ok
      end

      private

      def vehicle_params
        params.permit(:plate)
      end
    end
  end
end
