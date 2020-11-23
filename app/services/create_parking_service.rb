# frozen_string_literal: true

class CreateParkingService
  def initialize(vehicle_id)
    @vehicle_id = vehicle_id
  end

  def create
    valid_vehicle? ? create_parking_ticket : nil
  end

  private

  def valid_vehicle?
    Vehicle.find_by(id: @vehicle_id).present?
  end

  def create_parking_ticket
    Parking.create(
      entrance_date: Time.current,
      vehicle_id: @vehicle_id,
      status: 'initiated'
    )
  end
end
