# frozen_string_literal: true

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

      def exit_parking
        parking = Parking.find_by(id: params[:id])

        if parking.blank?
          render json: {
            response: 'Inform a valid booking reference number.'
          }, status: :not_found and return
        end

        unless parking.paid?
          render json: {
            response: 'Payment required',
            data: parking
          }, status: :payment_required and return
        end

        render json: {
          response: 'Vehicle has left successfully',
          data: parking
        }, status: :ok
      end

      private

      def vehicle_params
        params.permit(:plate)
      end
    end
  end
end
