# frozen_string_literal: true

module Api
  module V1
    class ParkingController < ApplicationController
      def create
        regex_match = vehicle_params[:plate] =~ /[A-Z]{3}-[0-9]{4}/

        if regex_match.nil?
          render json: {
            message: 'Invalid plate format. Use AAA-9999 pattern.'
          }, status: :bad_request and return
        end

        vehicle = Vehicle.find_or_create_by(vehicle_params)

        parking_ticket = Parking.create(
          entrance_date: Time.current,
          vehicle_id: vehicle.id
        )

        render json: {
          booking_reference_number: parking_ticket.id
        }, status: :ok
      end

      def exit_parking
        parking = Parking.find_by(id: params[:id])

        if parking.blank?
          render json: {
            message: 'Inform a valid booking reference number.'
          }, status: :not_found and return
        end

        unless parking.paid?
          render json: {
            message: 'Payment required.',
            data: parking
          }, status: :payment_required and return
        end

        if parking.exit_date.present?
          render json: {
            message: 'Vehicle already left parking.',
            data: parking
          }, status: :method_not_allowed and return
        end

        parking.update(exit_date: Time.current)

        render json: {
          message: 'Vehicle has left successfully.',
          data: parking
        }, status: :ok
      end

      def pay_parking
        parking = Parking.find_by(id: params[:id])

        if parking.blank?
          render json: {
            message: 'Inform a valid booking reference number.'
          }, status: :not_found and return
        end

        if parking.payment_date.present?
          render json: {
            message: 'Parking ticket has already paid.',
            data: parking
          }, status: :method_not_allowed and return
        end

        parking.update(payment_date: Time.current)

        render json: {
          message: 'Parking ticket has paid successfully.',
          data: parking
        }, status: :ok
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
            paid: parking.paid?,
            left: parking.vehicle_has_left?
          }

          parking_history << JSON.parse(parking_ticket.to_json)
        end

        render json: parking_history
      end

      private

      def vehicle_params
        params.permit(:plate)
      end
    end
  end
end
