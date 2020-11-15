# frozen_string_literal: true

class ParkingTicket < ApplicationRecord
  validates :entrance_date, presence: true
  validates :vehicle_id, presence: true

  belongs_to :vehicle
  belongs_to :payment
end
