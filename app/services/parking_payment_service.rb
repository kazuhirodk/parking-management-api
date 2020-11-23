# frozen_string_literal: true

class ParkingPaymentService
  def initialize(parking_id)
    @parking = Parking.find_by(id: parking_id)
  end

  def pay_parking
    return invalid_ticket_response if @parking.blank?
    return ticket_already_paid_response if @parking.paid?

    confirm_ticket_payment

    paid_successfully_response
  end

  private

  def confirm_ticket_payment
    @parking.update(payment_date: Time.current)
    @parking.paid!
  end

  def invalid_ticket_response(data = {})
    {
      message: 'Inform a valid booking reference number.',
      data: data,
      http_status: :not_found
    }
  end

  def ticket_already_paid_response(data = {})
    {
      message: 'Parking ticket has already paid.',
      data: data,
      http_status: :method_not_allowed
    }
  end

  def paid_successfully_response(data = {})
    {
      message: 'Parking ticket has paid successfully.',
      data: data,
      http_status: :ok
    }
  end
end
