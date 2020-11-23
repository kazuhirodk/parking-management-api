# frozen_string_literal: true

class ParkingEntranceService
  def initialize(vehicle_params = {})
    @vehicle = CreateVehicleService.new(vehicle_params).create
  end

  def enter_parking
    return invalid_vehicle_response if @vehicle.blank?

    parking_ticket = CreateParkingService.new(@vehicle.id).create

    enter_successfully_response({ ticket_number: parking_ticket.id })
  end

  private

  def invalid_vehicle_response(data = {})
    {
      message: 'Invalid plate format. Use AAA-9999 format.',
      data: data,
      http_status: :bad_request
    }
  end

  def enter_successfully_response(data = {})
    {
      message: 'Enter parking successfully.',
      data: data,
      http_status: :ok
    }
  end
end
