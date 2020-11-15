# frozen_string_literal: true

class AddParkingTicketRefToPayments < ActiveRecord::Migration[6.0]
  def change
    add_reference :payments, :parking_ticket, foreign_key: true
  end
end
