# frozen_string_literal: true

module Api
  module V1
    class ParkingController < ApplicationController
      def create
        response = ParkingEntranceService.new(vehicle_params).enter_parking

        render_json(
          { message: response[:message], data: response[:data] },
          response[:http_status]
        )
      end

      def left_parking
        response = ParkingExitService.new(params[:id]).left_parking

        render_json(
          { message: response[:message], data: response[:data] },
          response[:http_status]
        )
      end

      def pay_parking
        response = ParkingPaymentService.new(params[:id]).pay_parking

        render_json(
          { message: response[:message], data: response[:data] },
          response[:http_status]
        )
      end

      def parking_history
        vehicle = Vehicle.find_by(vehicle_params)

        if vehicle.blank?
          render json: {
            message: 'Inform a valid plate.'
          }, status: :not_found and return
        end

        all_parking = vehicle.parking
        parking_history = []

        all_parking.each do |parking|
          ticket_exit_date = parking.exit_date || Time.current
          parking_time_in_minutes = ((ticket_exit_date - parking.entrance_date) / 60).to_int

          parking_ticket = {
            id: parking.id,
            time: "#{parking_time_in_minutes} minutes",
            paid: parking.parking_paid?,
            left: parking.left?
          }

          parking_history << JSON.parse(parking_ticket.to_json)
        end

        render json: parking_history
      end

      private

      def vehicle_params
        params.permit(:plate)
      end

      def render_json(message, http_status)
        render json: { message: message }, status: http_status
      end
    end
  end
end
