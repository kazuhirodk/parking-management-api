# frozen_string_literal: true

class ParkingTicket < ApplicationRecord
  belongs_to :vehicle
  belongs_to :payment
end
