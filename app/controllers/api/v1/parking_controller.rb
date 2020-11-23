# frozen_string_literal: true

module Api
  module V1
    class ParkingController < ApplicationController
      def enter_parking
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
        response = ParkingHistoryService.new(vehicle_params).full_history

        render_json(response[:data], response[:http_status]) and return if response[:http_status] == :ok

        render_json(
          { message: response[:message], data: response[:data] },
          response[:http_status]
        )
      end

      private

      def vehicle_params
        params.permit(:plate)
      end

      def render_json(message, http_status)
        render json: message, status: http_status
      end
    end
  end
end
