# frozen_string_literal: true

class ParkingExitService
  def initialize(parking_id)
    @parking = Parking.find_by(id: parking_id)
  end

  def left_parking
    return invalid_ticket_response if @parking.blank?
    return payment_required_response unless @parking.parking_paid?
    return vehicle_already_left_response if @parking.left?

    confirm_vehicle_exit

    left_successfully_response
  end

  private

  def confirm_vehicle_exit
    @parking.update(exit_date: Time.current)
    @parking.left!
  end

  def invalid_ticket_response(data = {})
    {
      message: 'Ticket not found. Inform a valid ticket number.',
      data: data,
      http_status: :not_found
    }
  end

  def payment_required_response(data = {})
    {
      message: 'Payment required.',
      data: data,
      http_status: :payment_required
    }
  end

  def vehicle_already_left_response(data = {})
    {
      message: 'Vehicle already left parking.',
      data: data,
      http_status: :accepted
    }
  end

  def left_successfully_response(data = {})
    {
      message: 'Vehicle has left successfully.',
      data: data,
      http_status: :ok
    }
  end
end
