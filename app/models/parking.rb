# frozen_string_literal: true

class Parking < ApplicationRecord
  validates :entrance_date, presence: true
  validates :vehicle_id, presence: true

  belongs_to :vehicle
end
