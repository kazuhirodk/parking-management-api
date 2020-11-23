# frozen_string_literal: true

class ParkingHistoryService
  def initialize(vehicle_params = {})
    @vehicle = Vehicle.find_by(plate: vehicle_params[:plate])
    @parking_history = []
  end

  def full_history
    return invalid_vehicle_response if @vehicle.blank?

    history_list
  end

  private

  def history_list
    @vehicle.parking.each do |parking|
      parking_ticket = {
        id: parking.id,
        time: get_ticket_time_in_minutes(parking),
        paid: parking.parking_paid?,
        left: parking.left?
      }

      @parking_history << JSON.parse(parking_ticket.to_json)
    end

    full_history_response(@parking_history)
  end

  def get_ticket_time_in_minutes(parking)
    ticket_exit_date = parking.exit_date || Time.current
    parking_time_in_minutes = ((ticket_exit_date - parking.entrance_date) / 60).to_int

    "#{parking_time_in_minutes} minutes"
  end

  def invalid_vehicle_response(data = {})
    {
      message: 'Plate not found. Inform a valid plate.',
      data: data,
      http_status: :not_found
    }
  end

  def full_history_response(data = {})
    {
      message: 'Parking history was successfully obtained',
      data: data,
      http_status: :ok
    }
  end
end
