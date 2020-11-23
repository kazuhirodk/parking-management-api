# frozen_string_literal: true

class CreateVehicleService
  def initialize(params = {})
    @plate = params[:plate]
  end

  def create
    valid_plate? ? create_vehicle : nil
  end

  private

  def valid_plate?
    regex_match = @plate =~ /[A-Z]{3}-[0-9]{4}/

    !regex_match.nil?
  end

  def create_vehicle
    Vehicle.find_or_create_by(plate: @plate)
  end
end
